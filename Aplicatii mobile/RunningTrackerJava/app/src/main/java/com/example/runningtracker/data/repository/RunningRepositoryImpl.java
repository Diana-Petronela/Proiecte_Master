package com.example.runningtracker.data.repository;

import androidx.lifecycle.LiveData;

import com.example.runningtracker.data.local.RunDao;
import com.example.runningtracker.data.model.Run;

import java.util.List;

import javax.inject.Inject;

public class RunningRepositoryImpl implements RunningRepository {
    
    private final RunDao runDao;
    
    @Inject
    public RunningRepositoryImpl(RunDao runDao) {
        this.runDao = runDao;
    }
    
    @Override
    public void insertRun(Run run) {
        runDao.insertRun(run);
    }
    
    @Override
    public void deleteRun(Run run) {
        runDao.deleteRun(run);
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByDate() {
        return runDao.getAllRunsSortedByDate();
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByDistance() {
        return runDao.getAllRunsSortedByDistance();
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByTimeInMillis() {
        return runDao.getAllRunsSortedByTimeInMillis();
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByAvgSpeed() {
        return runDao.getAllRunsSortedByAvgSpeed();
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByCaloriesBurned() {
        return runDao.getAllRunsSortedByCaloriesBurned();
    }
    
    @Override
    public LiveData<List<Run>> getAllRunsSortedByEffort() {
        return runDao.getAllRunsSortedByEffort();
    }
    
    @Override
    public LiveData<Long> getTotalTimeInMillis() {
        return runDao.getTotalTimeInMillis();
    }
    
    @Override
    public LiveData<Integer> getTotalDistance() {
        return runDao.getTotalDistance();
    }
    
    @Override
    public LiveData<Integer> getTotalCaloriesBurned() {
        return runDao.getTotalCaloriesBurned();
    }
    
    @Override
    public LiveData<Float> getTotalAvgSpeed() {
        return runDao.getTotalAvgSpeed();
    }
    
    @Override
    public LiveData<Float> getAverageEffort() {
        return runDao.getAverageEffort();
    }
    
    @Override
    public LiveData<Float> getAverageAzimuth() {
        return runDao.getAverageAzimuth();
    }
}
