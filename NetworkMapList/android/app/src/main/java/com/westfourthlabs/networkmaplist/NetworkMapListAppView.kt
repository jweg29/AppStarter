package com.westfourthlabs.networkmaplist

import android.content.Context
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.calculateEndPadding
import androidx.compose.foundation.layout.calculateStartPadding
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.Button
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun NetworkMapListApp(context: Context, viewModel: FoodViewModel) {
    val layoutDirection = LocalLayoutDirection.current

    androidx.compose.material3.Surface(
        modifier = Modifier
            .fillMaxSize()
            .statusBarsPadding()
            .padding(
                start = WindowInsets.safeDrawing
                    .asPaddingValues()
                    .calculateStartPadding(layoutDirection),
                end = WindowInsets.safeDrawing
                    .asPaddingValues()
                    .calculateEndPadding(layoutDirection),
            ),
    ) {
        ItemsScreen(
            viewModel = viewModel
        )
    }
}

@Composable
fun ItemsScreen(viewModel: FoodViewModel) {
    viewModel.foodItems.value?.let { ItemsListView(foodItems = it) }
    val foodItems by viewModel.foodItems.observeAsState(emptyList())
    //ItemsListView(foodItems = foodItems)
}

@Composable
fun IdleView(onClick: () -> Unit) {
    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        Button(onClick = onClick) {
            Text("Load Items")
        }
    }
}

@Composable
fun LoadingView() {
    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        CircularProgressIndicator()
    }
}

@Composable
fun ItemsListView(foodItems: List<Food>) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(8.dp),
        contentPadding = PaddingValues(16.dp)
    ) {
        items(foodItems) { food ->
            foodItemView(food)
        }
    }
}

@Composable
fun foodItemView(food: Food) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable {

            },
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = food.name,
            style = MaterialTheme.typography.h6,
            modifier = Modifier
                .padding(16.dp)
        )
        //Spacer(modifier = Modifier.height(9.dp))
        Text(
            text = food.emoji,
            style = MaterialTheme.typography.h6,
            modifier = Modifier
                .padding(16.dp)
        )
    }
}

@Composable
fun ErrorView(message: String, onRetry: () -> Unit) {
    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(text = "Error: $message", color = MaterialTheme.colors.error)
            Spacer(modifier = Modifier.height(8.dp))
            Button(onClick = onRetry) {
                Text("Retry")
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun ItemsScreenPreview() {
    //ItemsScreen()
}