import { LightningElement, api, wire } from 'lwc';
import getFacilityHours from '@salesforce/apex/FacilityController.getFacilityHours';

export default class OpeningHoursComponent extends LightningElement {
    @api recordId;
    businessHours = [];

    @wire(getFacilityHours, { facilityId: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            this.businessHours = Object.keys(data).map(key => {
                return { label: key, value: data[key] };
            });
        } else if (error) {
            console.error('Error fetching operating hours:', error);
        }
    }
}