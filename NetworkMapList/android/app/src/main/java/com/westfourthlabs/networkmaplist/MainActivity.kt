package com.westfourthlabs.networkmaplist

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.westfourthlabs.networkmaplist.ui.theme.NetworkMapListTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.compose.foundation.layout.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // figure out view model.
        //val networkService = NetworkService.create()
        //val viewModel = FoodViewModel(networkService)
        //viewModel.fetchItems()
        val viewModel: FoodViewModel = FoodViewModel(NetworkService.create())
        val items by viewModel.items.observeAsState(emptyList())
        val errorMessage by viewModel.errorMess

        enableEdgeToEdge()
        setContent {
            NetworkMapListTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    ItemsScreen()
                }
            }
        }
    }
}

@Composable
fun ItemsScreen(/*viewModel: FoodViewModel = viewModel()*/) {
    //ItemsListView(foodItems = (viewModel.state as ViewState.Success).foodItems)

    /*val state by viewModel.state.collectAsState()

    when (state) {
        is ViewState.Idle -> IdleView { viewModel.fetchItems() }
        is ViewState.Loading -> LoadingView()
        is ViewState.Success -> ItemsListView(foodItems = (state as ViewState.Success).foodItems)
        is ViewState.Error -> ErrorView(message = (state as ViewState.Error).message) {
            viewModel.fetchItems()
        }
    }*/
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
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(16.dp)
    ) {
        /*items(foodItems) { food ->
            Text(
                text = food.name,
                style = MaterialTheme.typography.h6,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp)
            )
        }*/
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
    ItemsScreen()
}

/*

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    NetworkMapListTheme {
        Greeting("Android")
    }
}*/