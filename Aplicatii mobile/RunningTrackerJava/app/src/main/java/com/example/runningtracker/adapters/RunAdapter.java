package com.example.runningtracker.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.AsyncListDiffer;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.runningtracker.R;
import com.example.runningtracker.data.model.Run;
import com.example.runningtracker.util.TrackingUtility;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class RunAdapter extends RecyclerView.Adapter<RunAdapter.RunViewHolder> {

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd.MM.yy", Locale.getDefault());
    
    private final DiffUtil.ItemCallback<Run> diffCallback = new DiffUtil.ItemCallback<Run>() {
        @Override
        public boolean areItemsTheSame(@NonNull Run oldItem, @NonNull Run newItem) {
            return oldItem.getId() == newItem.getId();
        }

        @Override
        public boolean areContentsTheSame(@NonNull Run oldItem, @NonNull Run newItem) {
            return oldItem.getId().equals(newItem.getId()) &&
                   oldItem.getTimestamp() == newItem.getTimestamp() &&
                   oldItem.getAvgSpeedInKMH() == newItem.getAvgSpeedInKMH() &&
                   oldItem.getDistanceInMeters() == newItem.getDistanceInMeters() &&
                   oldItem.getTimeInMillis() == newItem.getTimeInMillis() &&
                   oldItem.getCaloriesBurned() == newItem.getCaloriesBurned();
        }
    };
    
    private final AsyncListDiffer<Run> differ = new AsyncListDiffer<>(this, diffCallback);

    @NonNull
    @Override
    public RunViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(
                R.layout.item_run,
                parent,
                false
        );
        return new RunViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RunViewHolder holder, int position) {
        Run run = differ.getCurrentList().get(position);
        holder.bind(run);
    }

    @Override
    public int getItemCount() {
        return differ.getCurrentList().size();
    }
    
    public void submitList(List<Run> runs) {
        differ.submitList(runs);
    }

    class RunViewHolder extends RecyclerView.ViewHolder {
        
        private ImageView ivRunImage;
        private TextView tvDate, tvAvgSpeed, tvDistance, tvTime, tvCaloriesBurned, tvEffort;

        public RunViewHolder(@NonNull View itemView) {
            super(itemView);
            ivRunImage = itemView.findViewById(R.id.ivRunImage);
            tvDate = itemView.findViewById(R.id.tvDate);
            tvAvgSpeed = itemView.findViewById(R.id.tvAvgSpeed);
            tvDistance = itemView.findViewById(R.id.tvDistance);
            tvTime = itemView.findViewById(R.id.tvTime);
            tvCaloriesBurned = itemView.findViewById(R.id.tvCaloriesBurned);
            tvEffort = itemView.findViewById(R.id.tvEffort);
        }
        
        void bind(Run run) {
            Glide.with(itemView.getContext())
                    .load(run.getImg())
                    .into(ivRunImage);
                    
            String date = dateFormat.format(new Date(run.getTimestamp()));
            String avgSpeed = run.getAvgSpeedInKMH() + " km/h";
            String distance = (run.getDistanceInMeters() / 1000f) + " km";
            String time = TrackingUtility.getFormattedStopWatchTime(run.getTimeInMillis());
            String calories = run.getCaloriesBurned() + " kcal";
            String effort = String.format(Locale.getDefault(), "%.1f", run.getEffort());
            
            tvDate.setText(date);
            tvAvgSpeed.setText(avgSpeed);
            tvDistance.setText(distance);
            tvTime.setText(time);
            tvCaloriesBurned.setText(calories);
            tvEffort.setText(effort);
        }
    }
}
