package com.example.runningtracker;

import android.app.Application;

import dagger.hilt.android.HiltAndroidApp;
import timber.log.Timber;

@HiltAndroidApp
public class MainApplication extends Application {
    
    @Override
    public void onCreate() {
        super.onCreate();
        
        // Inițializare Timber pentru logging
        if (BuildConfig.DEBUG) {
            Timber.plant(new Timber.DebugTree());
        }
    }
}
