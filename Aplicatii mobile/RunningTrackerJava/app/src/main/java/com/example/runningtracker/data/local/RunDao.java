package com.example.runningtracker.data.local;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import com.example.runningtracker.data.model.Run;

import java.util.List;

@Dao
public interface RunDao {
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insertRun(Run run);
    
    @Delete
    void deleteRun(Run run);
    
    @Query("SELECT * FROM running_table ORDER BY timestamp DESC")
    LiveData<List<Run>> getAllRunsSortedByDate();
    
    @Query("SELECT * FROM running_table ORDER BY timeInMillis DESC")
    LiveData<List<Run>> getAllRunsSortedByTimeInMillis();
    
    @Query("SELECT * FROM running_table ORDER BY caloriesBurned DESC")
    LiveData<List<Run>> getAllRunsSortedByCaloriesBurned();
    
    @Query("SELECT * FROM running_table ORDER BY avgSpeedInKMH DESC")
    LiveData<List<Run>> getAllRunsSortedByAvgSpeed();
    
    @Query("SELECT * FROM running_table ORDER BY distanceInMeters DESC")
    LiveData<List<Run>> getAllRunsSortedByDistance();
    
    @Query("SELECT * FROM running_table ORDER BY effort DESC")
    LiveData<List<Run>> getAllRunsSortedByEffort();
    
    @Query("SELECT SUM(timeInMillis) FROM running_table")
    LiveData<Long> getTotalTimeInMillis();
    
    @Query("SELECT SUM(caloriesBurned) FROM running_table")
    LiveData<Integer> getTotalCaloriesBurned();
    
    @Query("SELECT SUM(distanceInMeters) FROM running_table")
    LiveData<Integer> getTotalDistance();
    
    @Query("SELECT AVG(avgSpeedInKMH) FROM running_table")
    LiveData<Float> getTotalAvgSpeed();
    
    @Query("SELECT AVG(effort) FROM running_table")
    LiveData<Float> getAverageEffort();
    
    @Query("SELECT AVG(azimuth) FROM running_table")
    LiveData<Float> getAverageAzimuth();
}
