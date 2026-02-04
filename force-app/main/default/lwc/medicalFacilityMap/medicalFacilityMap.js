import { LightningElement, api, wire } from 'lwc';
import getFacilityDetails from '@salesforce/apex/MedicalFacilityController.getFacilityDetails';

export default class MedicalFacilityMap extends LightningElement {
    @api recordId;
    mapMarkers = [];
    error;

    @wire(getFacilityDetails, { recordId: '$recordId' })
    wiredFacility({ error, data }) {
        if (data) {
            this.mapMarkers = [
                {
                    location: {
                        Street: data.Facility_Address__Street__s,
                        City: data.Facility_Address__City__s,
                        PostalCode: data.Facility_Address__PostalCode__s,
                        State: data.Facility_Address__StateCode__s,
                        Country: data.Facility_Address__CountryCode__s
                    },
                    title: data.Name
                }
            ];
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error(error);
        }
    }
}