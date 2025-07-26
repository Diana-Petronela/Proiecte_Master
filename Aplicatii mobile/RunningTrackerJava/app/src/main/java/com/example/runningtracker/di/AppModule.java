package com.example.runningtracker.di;

import android.content.Context;

import androidx.room.Room;

import com.example.runningtracker.data.local.RunDao;
import com.example.runningtracker.data.local.RunningDatabase;
import com.example.runningtracker.data.repository.RunningRepository;
import com.example.runningtracker.data.repository.RunningRepositoryImpl;
import com.example.runningtracker.util.Constants;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;

@Module
@InstallIn(SingletonComponent.class)
public class AppModule {

    @Singleton
    @Provides
    public RunningDatabase provideRunningDatabase(
            @ApplicationContext Context app) {
        return Room.databaseBuilder(
                app,
                RunningDatabase.class,
                Constants.RUNNING_DATABASE_NAME
        ).build();
    }

    @Singleton
    @Provides
    public RunDao provideRunDao(RunningDatabase db) {
        return db.getRunDao();
    }

    @Singleton
    @Provides
    public RunningRepository provideRunningRepository(RunDao dao) {
        return new RunningRepositoryImpl(dao);
    }
}
