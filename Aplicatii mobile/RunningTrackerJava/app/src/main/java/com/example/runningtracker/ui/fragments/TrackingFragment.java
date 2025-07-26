package com.example.runningtracker.ui.fragments;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;

import com.example.runningtracker.R;
import com.example.runningtracker.databinding.FragmentTrackingBinding;
import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.service.TrackingService;
import com.example.runningtracker.ui.viewmodels.MainViewModel;
import com.example.runningtracker.util.Constants;
import com.example.runningtracker.util.TrackingUtility;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.PolylineOptions;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import com.google.android.material.snackbar.Snackbar;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;

@AndroidEntryPoint
public class TrackingFragment extends Fragment {

    private MainViewModel viewModel;
    private FragmentTrackingBinding binding;

    private GoogleMap map;

    private boolean isTracking = false;
    private ArrayList<ArrayList<LatLng>> pathPoints = new ArrayList<>();

    private long curTimeInMillis = 0L;
    private int currentHeartRate = 0;
    private float currentAzimuth = 0f;

    private Menu menu;

    private float weight = 80f; // Default weight in kg

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentTrackingBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(requireActivity()).get(MainViewModel.class);
        
        binding.mapView.onCreate(savedInstanceState);
        
        binding.btnToggleRun.setOnClickListener(v -> {
            toggleRun();
        });

        binding.btnFinishRun.setOnClickListener(v -> {
            zoomToSeeWholeTrack();
            endRunAndSaveToDb();
        });
        
        binding.mapView.getMapAsync(googleMap -> {
            map = googleMap;
            addAllPolylines();
        });

        subscribeToObservers();
    }

    private void subscribeToObservers() {
        TrackingService.isTracking.observe(getViewLifecycleOwner(), new Observer<Boolean>() {
            @Override
            public void onChanged(Boolean isTracking) {
                updateTracking(isTracking);
            }
        });

        TrackingService.pathPoints.observe(getViewLifecycleOwner(), new Observer<ArrayList<ArrayList<LatLng>>>() {
            @Override
            public void onChanged(ArrayList<ArrayList<LatLng>> pathPoints) {
                TrackingFragment.this.pathPoints = pathPoints;
                addLatestPolyline();
                moveCameraToUser();
            }
        });

        TrackingService.timeRunInMillis.observe(getViewLifecycleOwner(), new Observer<Long>() {
            @Override
            public void onChanged(Long timeInMillis) {
                curTimeInMillis = timeInMillis;
                String formattedTime = TrackingUtility.getFormattedStopWatchTime(curTimeInMillis, true);
                binding.tvTimer.setText(formattedTime);
            }
        });
        
        TrackingService.heartRate.observe(getViewLifecycleOwner(), new Observer<Integer>() {
            @Override
            public void onChanged(Integer heartRate) {
                currentHeartRate = heartRate;
                binding.tvHeartRate.setText(heartRate + " bpm");
                updateHeartRateColor(heartRate);
            }
        });
        
        TrackingService.azimuth.observe(getViewLifecycleOwner(), new Observer<Float>() {
            @Override
            public void onChanged(Float azimuth) {
                currentAzimuth = azimuth;
                binding.tvAzimuth.setText(((int) azimuth.floatValue()) + "°");
                binding.compassView.setRotation(-azimuth);
            }
        });
    }
    
    private void updateHeartRateColor(int heartRate) {
        int color;
        if (heartRate < 60) {
            color = Color.BLUE;
        } else if (heartRate < 100) {
            color = Color.GREEN;
        } else if (heartRate < 140) {
            color = Color.YELLOW;
        } else {
            color = Color.RED;
        }
        binding.tvHeartRate.setTextColor(color);
    }

    private void toggleRun() {
        if(isTracking) {
            if (menu != null) {
                menu.getItem(0).setVisible(true);
            }
            sendCommandToService(Constants.ACTION_PAUSE_SERVICE);
        } else {
            sendCommandToService(Constants.ACTION_START_OR_RESUME_SERVICE);
        }
    }

    @Override
    public void onCreateOptionsMenu(@NonNull Menu menu, @NonNull MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);
        inflater.inflate(R.menu.toolbar_tracking_menu, menu);
        this.menu = menu;
    }

    @Override
    public void onPrepareOptionsMenu(@NonNull Menu menu) {
        super.onPrepareOptionsMenu(menu);
        if(curTimeInMillis > 0L) {
            menu.getItem(0).setVisible(true);
        }
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == R.id.miCancelTracking) {
            showCancelTrackingDialog();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void showCancelTrackingDialog() {
        new MaterialAlertDialogBuilder(requireContext(), R.style.AlertDialogTheme)
            .setTitle("Cancel the Run?")
            .setMessage("Are you sure to cancel the current run and delete all its data?")
            .setIcon(R.drawable.ic_delete)
            .setPositiveButton("Yes", (dialogInterface, i) -> {
                stopRun();
            })
            .setNegativeButton("No", (dialogInterface, i) -> {
                dialogInterface.cancel();
            })
            .create()
            .show();
    }

    private void stopRun() {
        sendCommandToService(Constants.ACTION_STOP_SERVICE);
        Navigation.findNavController(requireView()).navigate(R.id.action_trackingFragment_to_runFragment);
    }

    private void updateTracking(boolean isTracking) {
        this.isTracking = isTracking;
        if(!isTracking && curTimeInMillis > 0L) {
            binding.btnToggleRun.setText("Start");
            binding.btnFinishRun.setVisibility(View.VISIBLE);
        } else if (isTracking) {
            binding.btnToggleRun.setText("Stop");
            if (menu != null) {
                menu.getItem(0).setVisible(true);
            }
            binding.btnFinishRun.setVisibility(View.GONE);
        }
    }

    private void moveCameraToUser() {
        if(pathPoints.size() > 0 && pathPoints.get(pathPoints.size() - 1).size() > 0) {
            LatLng lastPoint = pathPoints.get(pathPoints.size() - 1).get(pathPoints.get(pathPoints.size() - 1).size() - 1);
            map.animateCamera(
                CameraUpdateFactory.newLatLngZoom(
                    lastPoint,
                    Constants.MAP_ZOOM
                )
            );
        }
    }

    private void zoomToSeeWholeTrack() {
        LatLngBounds.Builder bounds = new LatLngBounds.Builder();
        for(ArrayList<LatLng> polyline : pathPoints) {
            for(LatLng point : polyline) {
                bounds.include(point);
            }
        }

        map.moveCamera(
            CameraUpdateFactory.newLatLngBounds(
                bounds.build(),
                binding.mapView.getWidth(),
                binding.mapView.getHeight(),
                (int)(binding.mapView.getHeight() * 0.05f)
            )
        );
    }

    private void endRunAndSaveToDb() {
        map.snapshot(bitmap -> {
            int distanceInMeters = 0;
            for(ArrayList<LatLng> polyline : pathPoints) {
                List<List<Double>> convertedPolyline = new ArrayList<>();
                for (LatLng point : polyline) {
                    List<Double> convertedPoint = new ArrayList<>();
                    convertedPoint.add(point.latitude);
                    convertedPoint.add(point.longitude);
                    convertedPolyline.add(convertedPoint);
                }
                distanceInMeters += TrackingUtility.calculatePolylineLength(convertedPolyline);
            }
            float avgSpeed = (distanceInMeters / 1000f) / (curTimeInMillis / 1000f / 60 / 60);
            avgSpeed = Math.round(avgSpeed * 10) / 10f;
            long dateTimestamp = Calendar.getInstance().getTimeInMillis();
            int caloriesBurned = TrackingUtility.calculateCaloriesBurned(weight, distanceInMeters, curTimeInMillis);
            float effort = TrackingUtility.calculateEffort(currentHeartRate, 220 - 30, curTimeInMillis);
            
            Run run = new Run(bitmap, dateTimestamp, avgSpeed, distanceInMeters, curTimeInMillis, caloriesBurned, currentHeartRate, effort, currentAzimuth);
            viewModel.insertRun(run);
            Snackbar.make(
                requireActivity().findViewById(R.id.rootView),
                "Run saved successfully",
                Snackbar.LENGTH_LONG
            ).show();
            stopRun();
        });
    }

    private void addAllPolylines() {
        for(ArrayList<LatLng> polyline : pathPoints) {
            PolylineOptions polylineOptions = new PolylineOptions()
                .color(Constants.POLYLINE_COLOR)
                .width(Constants.POLYLINE_WIDTH)
                .addAll(polyline);
            map.addPolyline(polylineOptions);
        }
    }

    private void addLatestPolyline() {
        if(pathPoints.size() > 0 && pathPoints.get(pathPoints.size() - 1).size() > 1) {
            ArrayList<LatLng> lastPolyline = pathPoints.get(pathPoints.size() - 1);
            LatLng preLastLatLng = lastPolyline.get(lastPolyline.size() - 2);
            LatLng lastLatLng = lastPolyline.get(lastPolyline.size() - 1);
            PolylineOptions polylineOptions = new PolylineOptions()
                .color(Constants.POLYLINE_COLOR)
                .width(Constants.POLYLINE_WIDTH)
                .add(preLastLatLng)
                .add(lastLatLng);
            map.addPolyline(polylineOptions);
        }
    }

    private void sendCommandToService(String action) {
        Intent intent = new Intent(requireContext(), TrackingService.class);
        intent.setAction(action);
        requireContext().startService(intent);
    }

    @Override
    public void onResume() {
        super.onResume();
        binding.mapView.onResume();
    }

    @Override
    public void onStart() {
        super.onStart();
        binding.mapView.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();
        binding.mapView.onStop();
    }

    @Override
    public void onPause() {
        super.onPause();
        binding.mapView.onPause();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        binding.mapView.onLowMemory();
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        super.onSaveInstanceState(outState);
        binding.mapView.onSaveInstanceState(outState);
    }
    
    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding.mapView.onDestroy();
        binding = null;
    }
}
