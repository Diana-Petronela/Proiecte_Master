package com.example.runningtracker.data.local;

import androidx.room.Database;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;

import com.example.runningtracker.data.model.Run;

@Database(
    entities = {Run.class},
    version = 1
)
@TypeConverters(Converters.class)
public abstract class RunningDatabase extends RoomDatabase {
    
    public abstract RunDao getRunDao();
}
