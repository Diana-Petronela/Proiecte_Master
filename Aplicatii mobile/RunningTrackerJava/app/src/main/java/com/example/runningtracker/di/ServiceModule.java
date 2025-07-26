package com.example.runningtracker.di;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import androidx.core.app.NotificationCompat;

import com.example.runningtracker.R;
import com.example.runningtracker.ui.MainActivity;
import com.example.runningtracker.util.Constants;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.components.ServiceComponent;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.android.scopes.ServiceScoped;

@Module
@InstallIn(ServiceComponent.class)
public class ServiceModule {

    @ServiceScoped
    @Provides
    public FusedLocationProviderClient provideFusedLocationProviderClient(
            @ApplicationContext Context app) {
        return LocationServices.getFusedLocationProviderClient(app);
    }

    @ServiceScoped
    @Provides
    public PendingIntent provideMainActivityPendingIntent(
            @ApplicationContext Context app) {
        Intent intent = new Intent(app, MainActivity.class);
        intent.setAction(Constants.ACTION_SHOW_TRACKING_FRAGMENT);
        return PendingIntent.getActivity(
                app,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
    }

    @ServiceScoped
    @Provides
    public NotificationCompat.Builder provideBaseNotificationBuilder(
            @ApplicationContext Context app,
            PendingIntent pendingIntent) {
        return new NotificationCompat.Builder(app, Constants.NOTIFICATION_CHANNEL_ID)
                .setAutoCancel(false)
                .setOngoing(true)
                .setSmallIcon(R.drawable.ic_directions_run_black_24dp)
                .setContentTitle("Running Tracker")
                .setContentText("00:00:00")
                .setContentIntent(pendingIntent);
    }
}
