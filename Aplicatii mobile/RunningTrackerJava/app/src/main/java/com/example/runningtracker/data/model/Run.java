package com.example.runningtracker.data.model;

import android.graphics.Bitmap;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "running_table")
public class Run {
    
    @PrimaryKey(autoGenerate = true)
    private Integer id;
    
    private Bitmap img;
    private long timestamp;
    private float avgSpeedInKMH;
    private int distanceInMeters;
    private long timeInMillis;
    private int caloriesBurned;
    private int avgHeartRate;
    private float effort;
    private float azimuth;
    
    public Run(Bitmap img, long timestamp, float avgSpeedInKMH, int distanceInMeters, 
               long timeInMillis, int caloriesBurned, int avgHeartRate, float effort, float azimuth) {
        this.img = img;
        this.timestamp = timestamp;
        this.avgSpeedInKMH = avgSpeedInKMH;
        this.distanceInMeters = distanceInMeters;
        this.timeInMillis = timeInMillis;
        this.caloriesBurned = caloriesBurned;
        this.avgHeartRate = avgHeartRate;
        this.effort = effort;
        this.azimuth = azimuth;
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Bitmap getImg() {
        return img;
    }
    
    public void setImg(Bitmap img) {
        this.img = img;
    }
    
    public long getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
    
    public float getAvgSpeedInKMH() {
        return avgSpeedInKMH;
    }
    
    public void setAvgSpeedInKMH(float avgSpeedInKMH) {
        this.avgSpeedInKMH = avgSpeedInKMH;
    }
    
    public int getDistanceInMeters() {
        return distanceInMeters;
    }
    
    public void setDistanceInMeters(int distanceInMeters) {
        this.distanceInMeters = distanceInMeters;
    }
    
    public long getTimeInMillis() {
        return timeInMillis;
    }
    
    public void setTimeInMillis(long timeInMillis) {
        this.timeInMillis = timeInMillis;
    }
    
    public int getCaloriesBurned() {
        return caloriesBurned;
    }
    
    public void setCaloriesBurned(int caloriesBurned) {
        this.caloriesBurned = caloriesBurned;
    }
    
    public int getAvgHeartRate() {
        return avgHeartRate;
    }
    
    public void setAvgHeartRate(int avgHeartRate) {
        this.avgHeartRate = avgHeartRate;
    }
    
    public float getEffort() {
        return effort;
    }
    
    public void setEffort(float effort) {
        this.effort = effort;
    }
    
    public float getAzimuth() {
        return azimuth;
    }
    
    public void setAzimuth(float azimuth) {
        this.azimuth = azimuth;
    }
}
