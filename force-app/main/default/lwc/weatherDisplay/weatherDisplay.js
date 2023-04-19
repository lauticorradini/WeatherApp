import { LightningElement, track } from 'lwc';
import fetchWeather from '@salesforce/apex/WeatherController.fetchWeather';

export default class WeatherDisplay extends LightningElement {
    @track city;

    handleCityChange(event) {
        this.city = event.target.value;
    }

    handleGetWeather() {
        fetchWeather({city: this.city})
            .then(result => {
                console.log('Weather information:', result);
                //TODO: display weather information on the page
            })
            .catch(error => {
                console.error('Error fetching weather information', error);
            });
    }
}
