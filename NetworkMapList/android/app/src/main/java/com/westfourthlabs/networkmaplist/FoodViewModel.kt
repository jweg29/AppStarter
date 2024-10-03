package com.westfourthlabs.networkmaplist
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelProvider.AndroidViewModelFactory.Companion.APPLICATION_KEY
import androidx.lifecycle.createSavedStateHandle
import androidx.lifecycle.viewmodel.CreationExtras


class FoodViewModel(/*private val apiService: NetworkService*/) : ViewModel() {

    val foodItems: LiveData<List<Food>> get() = _foodItems
    private val _foodItems = MutableLiveData<List<Food>>()

    //private val _state = MutableLiveData<ViewState>(ViewState.Idle)
    //val state: LiveData<ViewState> get() = _state

    //private val _errorMessage = MutableLiveData<String>()
    //val errorMessage: LiveData<String> get() = _errorMessage

    fun fetchItems() {
        viewModelScope.launch {
            try {
                val foods: List<Food> = arrayOf(
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                    Food(id = 0, name = "Tomatoe", emoji = "🍅"),
                    Food(id = 0, name = "potatoe", emoji = "🥔"),
                    Food(id = 0, name = "cucumber", emoji = "🥒"),
                    Food(id = 0, name = "broccoli", emoji = "🥦"),
                    Food(id = 0, name = "cake", emoji = "🍰"),
                    Food(id = 0, name = "pie", emoji = "🥧"),
                    Food(id = 0, name = "sushi", emoji = "🍣"),
                    Food(id = 0, name = "croissant", emoji = "🥐"),
                    Food(id = 0, name = "hot dog",emoji = "🌭"),
                    Food(id = 0, name = "hamburger", emoji = "🍔"),
                    Food(id = 0, name = "pizza", emoji = "🍕"),
                    Food(id = 0, name = "watermelon", emoji = "🍉"),
                    Food(id = 0, name = "blueberry", emoji = "🫐"),
                    Food(id = 0, name = "eggplant", emoji = "🍆"),
                    Food(id = 0, name = "bacon", emoji = "🥓"),
                    Food(id = 0, name = "strawberry", emoji = "🍓"),
                    Food(id = 0, name = "taco", emoji = "🌮"),
                    Food(id = 0, name = "pancakes", emoji = "🥞"),
                    Food(id = 0, name = "bagel", emoji = "🥯"),
                    Food(id = 0, name = "cupcake", emoji = "🧁"),
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                ).toList()
                _foodItems.value = foods
            } catch (e: Exception) {
                //_errorMessage.value = "Error fetching items: ${e.localizedMessage}"
            }
        }
    }
}

/*
class FoodViewModel(private val apiService: NetworkService) : ViewModel() {

    private val _state = MutableLiveData<ViewState>(ViewState.Idle)
    val state: LiveData<ViewState> get() = _state

    val foodItems: LiveData<List<Food>> get() = _foodItems
    private val _foodItems = MutableLiveData<List<Food>>()

    fun fetchItems() {
        _state.value = ViewState.Loading

        viewModelScope.launch {
            try {
                val foods: List<Food> = arrayOf(
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                ).toList()
                _state.value = ViewState.Success(foods)
                _foodItems.value = foods
            } catch (e: Exception) {
                _state.value = ViewState.Error(e.localizedMessage ?: "Unknown Error")
            }
        }
    }
}
*/
