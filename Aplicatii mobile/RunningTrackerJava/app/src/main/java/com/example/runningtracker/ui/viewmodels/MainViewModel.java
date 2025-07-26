package com.example.runningtracker.ui.viewmodels;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MediatorLiveData;
import androidx.lifecycle.ViewModel;

import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.data.repository.RunningRepository;
import com.example.runningtracker.util.SortType;

import java.util.List;

import javax.inject.Inject;

import dagger.hilt.android.lifecycle.HiltViewModel;

@HiltViewModel
public class MainViewModel extends ViewModel {

    private final RunningRepository runningRepository;
    
    private final MediatorLiveData<List<Run>> runs = new MediatorLiveData<>();
    private SortType sortType = SortType.DATE;

    @Inject
    public MainViewModel(RunningRepository runningRepository) {
        this.runningRepository = runningRepository;
        
        LiveData<List<Run>> runsSortedByDate = runningRepository.getAllRunsSortedByDate();
        LiveData<List<Run>> runsSortedByDistance = runningRepository.getAllRunsSortedByDistance();
        LiveData<List<Run>> runsSortedByCaloriesBurned = runningRepository.getAllRunsSortedByCaloriesBurned();
        LiveData<List<Run>> runsSortedByTimeInMillis = runningRepository.getAllRunsSortedByTimeInMillis();
        LiveData<List<Run>> runsSortedByAvgSpeed = runningRepository.getAllRunsSortedByAvgSpeed();
        LiveData<List<Run>> runsSortedByEffort = runningRepository.getAllRunsSortedByEffort();
        
        runs.addSource(runsSortedByDate, runs -> {
            if(sortType == SortType.DATE) {
                this.runs.setValue(runs);
            }
        });
        
        runs.addSource(runsSortedByDistance, runs -> {
            if(sortType == SortType.DISTANCE) {
                this.runs.setValue(runs);
            }
        });
        
        runs.addSource(runsSortedByCaloriesBurned, runs -> {
            if(sortType == SortType.CALORIES_BURNED) {
                this.runs.setValue(runs);
            }
        });
        
        runs.addSource(runsSortedByTimeInMillis, runs -> {
            if(sortType == SortType.RUNNING_TIME) {
                this.runs.setValue(runs);
            }
        });
        
        runs.addSource(runsSortedByAvgSpeed, runs -> {
            if(sortType == SortType.AVG_SPEED) {
                this.runs.setValue(runs);
            }
        });
        
        runs.addSource(runsSortedByEffort, runs -> {
            if(sortType == SortType.EFFORT) {
                this.runs.setValue(runs);
            }
        });
    }

    public void sortRuns(SortType sortType) {
        this.sortType = sortType;
        switch (sortType) {
            case DATE:
                runs.setValue(runningRepository.getAllRunsSortedByDate().getValue());
                break;
            case RUNNING_TIME:
                runs.setValue(runningRepository.getAllRunsSortedByTimeInMillis().getValue());
                break;
            case AVG_SPEED:
                runs.setValue(runningRepository.getAllRunsSortedByAvgSpeed().getValue());
                break;
            case DISTANCE:
                runs.setValue(runningRepository.getAllRunsSortedByDistance().getValue());
                break;
            case CALORIES_BURNED:
                runs.setValue(runningRepository.getAllRunsSortedByCaloriesBurned().getValue());
                break;
            case EFFORT:
                runs.setValue(runningRepository.getAllRunsSortedByEffort().getValue());
                break;
        }
    }

    public void insertRun(Run run) {
        runningRepository.insertRun(run);
    }
    
    public LiveData<List<Run>> getRuns() {
        return runs;
    }
}
