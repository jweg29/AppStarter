package com.westfourthlabs.networkmaplist
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData

class FoodViewModel(private val apiService: NetworkService) : ViewModel() {

    private val _items = MutableLiveData<List<Food>>()
    val items: LiveData<List<Food>> get() = _items

    private val _errorMessage = MutableLiveData<String>()
    val errorMessage: LiveData<String> get() = _errorMessage

    fun fetchItems() {
        viewModelScope.launch {
            try {
                //val food1 = Food(id = 0, name = "Apple", emoji = "🍎")
                val foods: Array<Food> = arrayOf(
                    Food(id = 0, name = "Apple", emoji = "🍎"),
                    Food(id = 0, name = "Banana", emoji = "🍌"),
                    Food(id = 0, name = "Cake", emoji = "🍰"),
                    Food(id = 0, name = "Spaghetti", emoji = "🍝"),
                    Food(id = 0, name = "Steak", emoji = "🥩"),
                )

                //val fetchedItems = apiService.fetchItems()
                _items.value = foods.toList()
            } catch (e: Exception) {
                _errorMessage.value = "Error fetching items: ${e.localizedMessage}"
            }
        }
    }
}
/*class FoodViewModel(private val apiService: NetworkService) : ViewModel() {

    private val _state = MutableLiveData<ViewState>(ViewState.Idle)
    val state: LiveData<ViewState> get() = _state

    fun fetchItems() {
        _state.value = ViewState.Loading

        viewModelScope.launch {
            try {
                val food = apiService.fetchItems()
                _state.value = ViewState.Success(food)
            } catch (e: Exception) {
                _state.value = ViewState.Error(e.localizedMessage ?: "Unknown Error")
            }
        }
    }
}*/