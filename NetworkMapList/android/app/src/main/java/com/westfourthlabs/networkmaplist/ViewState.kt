package com.westfourthlabs.networkmaplist

sealed class ViewState {
    object Idle : ViewState()
    object Loading : ViewState()
    data class Success(val foodItems: List<Food>) : ViewState()
    data class Error(val message: String) : ViewState()
}