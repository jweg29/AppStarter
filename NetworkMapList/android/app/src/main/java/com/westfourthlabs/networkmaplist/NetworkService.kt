package com.westfourthlabs.networkmaplist
import retrofit2.http.GET
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface NetworkService {
    @GET("food")
    suspend fun fetchItems(): List<Food>

    companion object {
        private const val BASE_URL = "http://10.0.2.2:3000/api/food/"

        fun create(): NetworkService {
            return Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
                .create(NetworkService::class.java)
        }
    }
}