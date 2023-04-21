import { LightningElement, track, wire } from 'lwc';
import fetchWeather from '@salesforce/apex/WeatherController.fetchWeather';

export default class WeatherDisplay extends LightningElement {
    @track city;
    display;

    handleCityChange(event) {
        this.city = event.target.value;
    }

    @wire(fetchWeather, {city: '$city'})
    wiredWeather({data, error}){
        if (data){
            this.display = {
                city: data[0].City__c,
                country: data[0].Country__c,
                weather: data[0].Name,
                description: data[0].WeatherDescription__c,
                temperature: data[0].Temperature__c,
                humidity: data[0].Humidity__c,
                wind: data[0].Wind__c,
                icon: data[0].Icon__c
            }
        } else if(error){
            console.error('Error fetching weather information', error);
            this.display = undefined;
        }
    }
}
