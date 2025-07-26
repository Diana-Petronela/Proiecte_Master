package com.example.runningtracker.util;

import android.Manifest;
import android.content.Context;
import android.location.Location;
import android.os.Build;

import java.util.concurrent.TimeUnit;

import pub.devrel.easypermissions.EasyPermissions;

public class TrackingUtility {
    
    public static boolean hasLocationPermissions(Context context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return EasyPermissions.hasPermissions(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            );
        } else {
            return EasyPermissions.hasPermissions(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION
            );
        }
    }
    
    public static float calculatePolylineLength(java.util.List<java.util.List<Double>> polyline) {
        float distance = 0;
        for(int i = 0; i < polyline.size() - 1; i++) {
            java.util.List<Double> pos1 = polyline.get(i);
            java.util.List<Double> pos2 = polyline.get(i + 1);
            
            float[] result = new float[1];
            Location.distanceBetween(
                pos1.get(0),
                pos1.get(1),
                pos2.get(0),
                pos2.get(1),
                result
            );
            distance += result[0];
        }
        return distance;
    }
    
    public static String getFormattedStopWatchTime(long ms, boolean includeMillis) {
        long milliseconds = ms;
        long hours = TimeUnit.MILLISECONDS.toHours(milliseconds);
        milliseconds -= TimeUnit.HOURS.toMillis(hours);
        long minutes = TimeUnit.MILLISECONDS.toMinutes(milliseconds);
        milliseconds -= TimeUnit.MINUTES.toMillis(minutes);
        long seconds = TimeUnit.MILLISECONDS.toSeconds(milliseconds);
        
        if(!includeMillis) {
            return String.format("%02d:%02d:%02d", hours, minutes, seconds);
        }
        
        milliseconds -= TimeUnit.SECONDS.toMillis(seconds);
        milliseconds /= 10;
        return String.format("%02d:%02d:%02d:%02d", hours, minutes, seconds, milliseconds);
    }
    
    public static String getFormattedStopWatchTime(long ms) {
        return getFormattedStopWatchTime(ms, false);
    }
    
    public static int calculateCaloriesBurned(float weightInKg, int distanceInMeters, long timeInMillis) {
        // MET value for running (varies by speed)
        float speedInKmh = (distanceInMeters / 1000f) / (timeInMillis / 1000f / 60 / 60);
        double met;
        
        if (speedInKmh < 6.4) {
            met = 6.0;  // Jogging
        } else if (speedInKmh < 8.0) {
            met = 8.3;  // Light running
        } else if (speedInKmh < 9.7) {
            met = 9.8;  // Moderate running
        } else if (speedInKmh < 11.3) {
            met = 11.0; // Fast running
        } else {
            met = 12.3; // Very fast running
        }
        
        // Calories = MET * weight in kg * time in hours
        float timeInHours = timeInMillis / 1000f / 60 / 60;
        return (int)(met * weightInKg * timeInHours);
    }
    
    public static float calculateEffort(int heartRate, int maxHeartRate, long timeInMillis) {
        // Calculate effort based on heart rate zones and duration
        float hrPercentage = (float)heartRate / (float)maxHeartRate;
        float effortFactor;
        
        if (hrPercentage < 0.6) {
            effortFactor = 1.0f;  // Easy zone
        } else if (hrPercentage < 0.7) {
            effortFactor = 2.0f;  // Fat burning zone
        } else if (hrPercentage < 0.8) {
            effortFactor = 3.0f;  // Aerobic zone
        } else if (hrPercentage < 0.9) {
            effortFactor = 4.0f;  // Anaerobic zone
        } else {
            effortFactor = 5.0f;  // Maximum zone
        }
        
        // Effort increases with duration
        float durationFactor = timeInMillis / 60000f; // minutes
        
        return effortFactor * (1 + durationFactor / 60); // Effort increases with each hour
    }
}
