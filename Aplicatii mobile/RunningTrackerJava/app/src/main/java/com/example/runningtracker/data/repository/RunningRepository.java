package com.example.runningtracker.data.repository;

import androidx.lifecycle.LiveData;

import com.example.runningtracker.data.model.Run;

import java.util.List;

public interface RunningRepository {
    
    void insertRun(Run run);
    
    void deleteRun(Run run);
    
    LiveData<List<Run>> getAllRunsSortedByDate();
    
    LiveData<List<Run>> getAllRunsSortedByDistance();
    
    LiveData<List<Run>> getAllRunsSortedByTimeInMillis();
    
    LiveData<List<Run>> getAllRunsSortedByAvgSpeed();
    
    LiveData<List<Run>> getAllRunsSortedByCaloriesBurned();
    
    LiveData<List<Run>> getAllRunsSortedByEffort();
    
    LiveData<Long> getTotalTimeInMillis();
    
    LiveData<Integer> getTotalDistance();
    
    LiveData<Integer> getTotalCaloriesBurned();
    
    LiveData<Float> getTotalAvgSpeed();
    
    LiveData<Float> getAverageEffort();
    
    LiveData<Float> getAverageAzimuth();
}
