package com.example.runningtracker.ui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;

import com.example.runningtracker.R;
import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.databinding.FragmentStatisticsBinding;
import com.example.runningtracker.ui.viewmodels.StatisticsViewModel;
import com.example.runningtracker.util.TrackingUtility;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;

import java.util.ArrayList;
import java.util.List;

import dagger.hilt.android.AndroidEntryPoint;

@AndroidEntryPoint
public class StatisticsFragment extends Fragment {

    private StatisticsViewModel viewModel;
    private FragmentStatisticsBinding binding;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentStatisticsBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        viewModel = new ViewModelProvider(requireActivity()).get(StatisticsViewModel.class);
        
        subscribeToObservers();
        setupBarChart();
    }
    
    private void setupBarChart() {
        binding.barChart.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        binding.barChart.getXAxis().setDrawLabels(true);
        binding.barChart.getXAxis().setAxisLineColor(R.color.colorPrimary);
        binding.barChart.getXAxis().setTextColor(R.color.colorPrimary);
        binding.barChart.getXAxis().setDrawGridLines(false);
        
        binding.barChart.getAxisLeft().setAxisLineColor(R.color.colorPrimary);
        binding.barChart.getAxisLeft().setTextColor(R.color.colorPrimary);
        binding.barChart.getAxisLeft().setDrawGridLines(false);
        
        binding.barChart.getAxisRight().setAxisLineColor(R.color.colorPrimary);
        binding.barChart.getAxisRight().setTextColor(R.color.colorPrimary);
        binding.barChart.getAxisRight().setDrawGridLines(false);
        
        binding.barChart.getDescription().setText("Avg Speed Over Time");
        binding.barChart.getLegend().setEnabled(false);
    }

    private void subscribeToObservers() {
        viewModel.getTotalTimeRun().observe(getViewLifecycleOwner(), new Observer<Long>() {
            @Override
            public void onChanged(Long timeInMillis) {
                if (timeInMillis != null) {
                    String totalTimeRun = TrackingUtility.getFormattedStopWatchTime(timeInMillis);
                    binding.tvTotalTime.setText(totalTimeRun);
                }
            }
        });
        
        viewModel.getTotalDistance().observe(getViewLifecycleOwner(), new Observer<Integer>() {
            @Override
            public void onChanged(Integer distance) {
                if (distance != null) {
                    float km = distance / 1000f;
                    float totalDistance = Math.round(km * 10f) / 10f;
                    String totalDistanceString = totalDistance + "km";
                    binding.tvTotalDistance.setText(totalDistanceString);
                }
            }
        });
        
        viewModel.getTotalAvgSpeed().observe(getViewLifecycleOwner(), new Observer<Float>() {
            @Override
            public void onChanged(Float avgSpeed) {
                if (avgSpeed != null) {
                    float roundedAvgSpeed = Math.round(avgSpeed * 10f) / 10f;
                    String avgSpeedString = roundedAvgSpeed + "km/h";
                    binding.tvAverageSpeed.setText(avgSpeedString);
                }
            }
        });
        
        viewModel.getTotalCaloriesBurned().observe(getViewLifecycleOwner(), new Observer<Integer>() {
            @Override
            public void onChanged(Integer calories) {
                if (calories != null) {
                    String totalCalories = calories + "kcal";
                    binding.tvTotalCalories.setText(totalCalories);
                }
            }
        });
        
        viewModel.getAverageEffort().observe(getViewLifecycleOwner(), new Observer<Float>() {
            @Override
            public void onChanged(Float effort) {
                if (effort != null) {
                    float roundedEffort = Math.round(effort * 10f) / 10f;
                    binding.tvAverageEffort.setText(String.valueOf(roundedEffort));
                }
            }
        });
        
        viewModel.getRunsSortedByDate().observe(getViewLifecycleOwner(), new Observer<List<Run>>() {
            @Override
            public void onChanged(List<Run> runs) {
                if (runs != null) {
                    List<BarEntry> allAvgSpeeds = new ArrayList<>();
                    for (int i = 0; i < runs.size(); i++) {
                        allAvgSpeeds.add(new BarEntry(i, runs.get(i).getAvgSpeedInKMH()));
                    }
                    BarDataSet barDataSet = new BarDataSet(allAvgSpeeds, "Avg Speed Over Time");
                    barDataSet.setValueTextColor(R.color.colorPrimary);
                    barDataSet.setColor(R.color.colorAccent);
                    
                    binding.barChart.setData(new BarData(barDataSet));
                    binding.barChart.invalidate();
                }
            }
        });
    }
    
    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
