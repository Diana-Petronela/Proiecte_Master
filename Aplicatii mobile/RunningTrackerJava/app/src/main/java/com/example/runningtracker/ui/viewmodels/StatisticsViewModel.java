package com.example.runningtracker.ui.viewmodels;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModel;

import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.data.repository.RunningRepository;

import java.util.List;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

@HiltViewModel
public class StatisticsViewModel extends ViewModel {

    private final RunningRepository runningRepository;

    @Inject
    public StatisticsViewModel(RunningRepository runningRepository) {
        this.runningRepository = runningRepository;
    }
    
    public LiveData<Long> getTotalTimeRun() {
        return runningRepository.getTotalTimeInMillis();
    }
    
    public LiveData<Integer> getTotalDistance() {
        return runningRepository.getTotalDistance();
    }
    
    public LiveData<Integer> getTotalCaloriesBurned() {
        return runningRepository.getTotalCaloriesBurned();
    }
    
    public LiveData<Float> getTotalAvgSpeed() {
        return runningRepository.getTotalAvgSpeed();
    }
    
    public LiveData<Float> getAverageEffort() {
        return runningRepository.getAverageEffort();
    }
    
    public LiveData<Float> getAverageAzimuth() {
        return runningRepository.getAverageAzimuth();
    }
    
    public LiveData<List<Run>> getRunsSortedByDate() {
        return runningRepository.getAllRunsSortedByDate();
    }
}
