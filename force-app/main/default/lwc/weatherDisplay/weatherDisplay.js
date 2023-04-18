import { LightningElement, wire } from 'lwc';
import weatherController from '@salesforce/apex/WeatherController.fetchWeather';

export default class WeatherDisplay extends LightningElement {
    search;
    error;

    @wire(weatherController, {
        city : '$city'
    })
    wiredCity({data, error}){
        if(data){
            if(this.search !== data){
                this.search = data;
            }
        } else if(error){
            this.error = error;
        }
    }
}