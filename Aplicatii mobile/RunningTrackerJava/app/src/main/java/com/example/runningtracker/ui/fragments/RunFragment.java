package com.example.runningtracker.ui.fragments;

import android.Manifest;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.example.runningtracker.R;
import com.example.runningtracker.adapters.RunAdapter;
import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.databinding.FragmentRunBinding;
import com.example.runningtracker.ui.viewmodels.MainViewModel;
import com.example.runningtracker.util.Constants;
import com.example.runningtracker.util.SortType;
import com.example.runningtracker.util.TrackingUtility;

import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;
import pub.devrel.easypermissions.AppSettingsDialog;
import pub.devrel.easypermissions.EasyPermissions;

@AndroidEntryPoint
public class RunFragment extends Fragment implements EasyPermissions.PermissionCallbacks {

    private MainViewModel viewModel;
    private RunAdapter runAdapter;
    private FragmentRunBinding binding;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentRunBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(requireActivity()).get(MainViewModel.class);
        
        requestPermissions();
        setupRecyclerView();
        
        binding.fab.setOnClickListener(v -> {
            Navigation.findNavController(view).navigate(R.id.action_runFragment_to_trackingFragment);
        });
        
        binding.spFilter.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int pos, long id) {
                switch(pos) {
                    case 0:
                        viewModel.sortRuns(SortType.DATE);
                        break;
                    case 1:
                        viewModel.sortRuns(SortType.RUNNING_TIME);
                        break;
                    case 2:
                        viewModel.sortRuns(SortType.DISTANCE);
                        break;
                    case 3:
                        viewModel.sortRuns(SortType.AVG_SPEED);
                        break;
                    case 4:
                        viewModel.sortRuns(SortType.CALORIES_BURNED);
                        break;
                    case 5:
                        viewModel.sortRuns(SortType.EFFORT);
                        break;
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {}
        });
        
        viewModel.getRuns().observe(getViewLifecycleOwner(), new Observer<List<Run>>() {
            @Override
            public void onChanged(List<Run> runs) {
                runAdapter.submitList(runs);
            }
        });
    }
    
    private void setupRecyclerView() {
        runAdapter = new RunAdapter();
        binding.rvRuns.setAdapter(runAdapter);
        binding.rvRuns.setLayoutManager(new LinearLayoutManager(requireContext()));
    }
    
    private void requestPermissions() {
        if(TrackingUtility.hasLocationPermissions(requireContext())) {
            return;
        }
        if(Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            EasyPermissions.requestPermissions(
                this,
                "You need to accept location permissions to use this app.",
                Constants.REQUEST_CODE_LOCATION_PERMISSION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION
            );
        } else {
            EasyPermissions.requestPermissions(
                this,
                "You need to accept location permissions to use this app.",
                Constants.REQUEST_CODE_LOCATION_PERMISSION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION
            );
        }
    }

    @Override
    public void onPermissionsGranted(int requestCode, @NonNull List<String> perms) {}

    @Override
    public void onPermissionsDenied(int requestCode, @NonNull List<String> perms) {
        if(EasyPermissions.somePermissionPermanentlyDenied(this, perms)) {
            new AppSettingsDialog.Builder(this).build().show();
        } else {
            requestPermissions();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this);
    }
    
    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
