package com.example.runningtracker.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.NavigationUI;

import com.example.runningtracker.R;
import com.example.runningtracker.databinding.ActivityMainBinding;
import com.example.runningtracker.util.Constants;

import dagger.hilt.android.AndroidEntryPoint;

@AndroidEntryPoint
public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        navigateToTrackingFragmentIfNeeded(getIntent());

        setSupportActionBar(binding.toolbar);
        
        NavHostFragment navHostFragment = 
                (NavHostFragment) getSupportFragmentManager().findFragmentById(R.id.navHostFragment);
        NavController navController = navHostFragment.getNavController();

        NavigationUI.setupWithNavController(binding.bottomNavigationView, navController);
        
        navController.addOnDestinationChangedListener((controller, destination, arguments) -> {
            if(destination.getId() == R.id.settingsFragment || 
               destination.getId() == R.id.runFragment || 
               destination.getId() == R.id.statisticsFragment) {
                binding.bottomNavigationView.setVisibility(View.VISIBLE);
            } else {
                binding.bottomNavigationView.setVisibility(View.GONE);
            }
        });
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        navigateToTrackingFragmentIfNeeded(intent);
    }

    private void navigateToTrackingFragmentIfNeeded(Intent intent) {
        if(intent != null && intent.getAction() != null) {
            if(intent.getAction().equals(Constants.ACTION_SHOW_TRACKING_FRAGMENT)) {
                NavHostFragment navHostFragment = 
                        (NavHostFragment) getSupportFragmentManager().findFragmentById(R.id.navHostFragment);
                NavController navController = navHostFragment.getNavController();
                navController.navigate(R.id.action_global_trackingFragment);
            }
        }
    }
}
