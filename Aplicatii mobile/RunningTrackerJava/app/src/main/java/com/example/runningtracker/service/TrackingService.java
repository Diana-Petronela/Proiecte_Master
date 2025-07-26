package com.example.runningtracker.service;

import android.annotation.SuppressLint;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.os.Build;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.lifecycle.LifecycleService;
import androidx.lifecycle.MutableLiveData;

import com.example.runningtracker.util.Constants;
import com.example.runningtracker.util.TrackingUtility;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.Priority;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;

import javax.inject.Inject;

import dagger.hilt.android.AndroidEntryPoint;
import timber.log.Timber;

@AndroidEntryPoint
public class TrackingService extends LifecycleService implements SensorEventListener {

    private boolean isFirstRun = true;
    private boolean serviceKilled = false;

    @Inject
    FusedLocationProviderClient fusedLocationProviderClient;

    @Inject
    NotificationCompat.Builder baseNotificationBuilder;

    private NotificationCompat.Builder curNotificationBuilder;

    private final MutableLiveData<Long> timeRunInSeconds = new MutableLiveData<>();

    private boolean isTimerEnabled = false;
    private long lapTime = 0L;
    private long timeRun = 0L;
    private long timeStarted = 0L;
    private long lastSecondTimestamp = 0L;

    private int currentHeartRate = 0;
    private float currentAzimuth = 0f;

    private SensorManager sensorManager;
    private Sensor heartRateSensor;
    private Sensor orientationSensor;

    public static final MutableLiveData<Boolean> isTracking = new MutableLiveData<>();
    public static final MutableLiveData<ArrayList<ArrayList<LatLng>>> pathPoints = new MutableLiveData<>();
    public static final MutableLiveData<Long> timeRunInMillis = new MutableLiveData<>();
    public static final MutableLiveData<Integer> heartRate = new MutableLiveData<>();
    public static final MutableLiveData<Float> azimuth = new MutableLiveData<>();

    private void postInitialValues() {
        isTracking.postValue(false);
        pathPoints.postValue(new ArrayList<>());
        timeRunInSeconds.postValue(0L);
        timeRunInMillis.postValue(0L);
        heartRate.postValue(0);
        azimuth.postValue(0f);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        curNotificationBuilder = baseNotificationBuilder;
        postInitialValues();
        fusedLocationProviderClient = new FusedLocationProviderClient(this);

        isTracking.observe(this, isTracking -> {
            updateLocationTracking(isTracking);
            updateNotificationTrackingState(isTracking);
        });

        // Initialize sensors
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE);
        orientationSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null) {
            switch (intent.getAction()) {
                case Constants.ACTION_START_OR_RESUME_SERVICE:
                    if (isFirstRun) {
                        startForegroundService();
                        isFirstRun = false;
                    } else {
                        Timber.d("Resuming service...");
                        startTimer();
                    }
                    break;
                case Constants.ACTION_PAUSE_SERVICE:
                    Timber.d("Paused service");
                    pauseService();
                    break;
                case Constants.ACTION_STOP_SERVICE:
                    Timber.d("Stopped service");
                    killService();
                    break;
            }
        }
        return super.onStartCommand(intent, flags, startId);
    }

    private void killService() {
        serviceKilled = true;
        isFirstRun = true;
        pauseService();
        postInitialValues();
        stopForeground(true);
        stopSelf();
    }

    private void pauseService() {
        isTracking.postValue(false);
        isTimerEnabled = false;
        unregisterSensors();
    }

    private void startTimer() {
        addEmptyPolyline();
        isTracking.postValue(true);
        timeStarted = System.currentTimeMillis();
        isTimerEnabled = true;
        registerSensors();
        
        new Thread(() -> {
            while (isTracking.getValue()) {
                // time difference between now and timeStarted
                lapTime = System.currentTimeMillis() - timeStarted;
                // post the new lapTime
                timeRunInMillis.postValue(timeRun + lapTime);
                if (timeRunInMillis.getValue() >= lastSecondTimestamp + 1000L) {
                    timeRunInSeconds.postValue(timeRunInSeconds.getValue() + 1);
                    lastSecondTimestamp += 1000L;
                }
                try {
                    Thread.sleep(Constants.TIMER_UPDATE_INTERVAL);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            timeRun += lapTime;
        }).start();
    }

    private void registerSensors() {
        if (heartRateSensor != null) {
            sensorManager.registerListener(this, heartRateSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
        if (orientationSensor != null) {
            sensorManager.registerListener(this, orientationSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    private void unregisterSensors() {
        sensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_HEART_RATE) {
            currentHeartRate = (int) event.values[0];
            heartRate.postValue(currentHeartRate);
        } else if (event.sensor.getType() == Sensor.TYPE_ORIENTATION) {
            currentAzimuth = event.values[0];
            azimuth.postValue(currentAzimuth);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Not needed for this implementation
    }

    private void addEmptyPolyline() {
        ArrayList<ArrayList<LatLng>> pathPointsValue = pathPoints.getValue();
        if (pathPointsValue != null) {
            pathPointsValue.add(new ArrayList<>());
            pathPoints.postValue(pathPointsValue);
        } else {
            ArrayList<ArrayList<LatLng>> pathPointsList = new ArrayList<>();
            pathPointsList.add(new ArrayList<>());
            pathPoints.postValue(pathPointsList);
        }
    }

    private void addPathPoint(Location location) {
        if (location != null) {
            LatLng pos = new LatLng(location.getLatitude(), location.getLongitude());
            ArrayList<ArrayList<LatLng>> pathPointsValue = pathPoints.getValue();
            if (pathPointsValue != null) {
                pathPointsValue.get(pathPointsValue.size() - 1).add(pos);
                pathPoints.postValue(pathPointsValue);
            }
        }
    }

    private final LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(@NonNull LocationResult locationResult) {
            super.onLocationResult(locationResult);
            if (isTracking.getValue()) {
                for (Location location : locationResult.getLocations()) {
                    addPathPoint(location);
                    Timber.d("NEW LOCATION: %s, %s", location.getLatitude(), location.getLongitude());
                }
            }
        }
    };

    @SuppressLint("MissingPermission")
    private void updateLocationTracking(boolean isTracking) {
        if (isTracking) {
            if (TrackingUtility.hasLocationPermissions(this)) {
                LocationRequest request = new LocationRequest.Builder(
                        Priority.PRIORITY_HIGH_ACCURACY,
                        Constants.LOCATION_UPDATE_INTERVAL)
                        .setMinUpdateIntervalMillis(Constants.FASTEST_LOCATION_INTERVAL)
                        .setWaitForAccurateLocation(false)
                        .build();

                fusedLocationProviderClient.requestLocationUpdates(
                        request,
                        locationCallback,
                        Looper.getMainLooper()
                );
            }
        } else {
            fusedLocationProviderClient.removeLocationUpdates(locationCallback);
        }
    }

    private void updateNotificationTrackingState(boolean isTracking) {
        String notificationActionText = isTracking ? "Pause" : "Resume";
        PendingIntent pendingIntent;
        
        if (isTracking) {
            Intent pauseIntent = new Intent(this, TrackingService.class);
            pauseIntent.setAction(Constants.ACTION_PAUSE_SERVICE);
            pendingIntent = PendingIntent.getService(
                    this,
                    1,
                    pauseIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
        } else {
            Intent resumeIntent = new Intent(this, TrackingService.class);
            resumeIntent.setAction(Constants.ACTION_START_OR_RESUME_SERVICE);
            pendingIntent = PendingIntent.getService(
                    this,
                    2,
                    resumeIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        // Clear all actions from the notification
        curNotificationBuilder = baseNotificationBuilder;
        
        if (!serviceKilled) {
            curNotificationBuilder = baseNotificationBuilder
                    .addAction(android.R.drawable.ic_media_pause, notificationActionText, pendingIntent);
            notificationManager.notify(Constants.NOTIFICATION_ID, curNotificationBuilder.build());
        }
    }

    private void startForegroundService() {
        startTimer();
        isTracking.postValue(true);

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel(notificationManager);
        }

        startForeground(Constants.NOTIFICATION_ID, baseNotificationBuilder.build());

        timeRunInSeconds.observe(this, seconds -> {
            if (!serviceKilled) {
                NotificationCompat.Builder notification = curNotificationBuilder
                        .setContentText(TrackingUtility.getFormattedStopWatchTime(seconds * 1000L));
                notificationManager.notify(Constants.NOTIFICATION_ID, notification.build());
            }
        });
    }

    private void createNotificationChannel(NotificationManager notificationManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    Constants.NOTIFICATION_CHANNEL_ID,
                    Constants.NOTIFICATION_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_LOW
            );
            notificationManager.createNotificationChannel(channel);
        }
    }
}
