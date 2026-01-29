import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import MEDICAL_APPOINTMENT_OBJECT from '@salesforce/schema/Medical_Appointment__c';
import PERSON_OBJECT from '@salesforce/schema/Person__c';
import SPECIALIZATION_FIELD from '@salesforce/schema/Person__c.Specialization__c';

import getAvailableDoctors from '@salesforce/apex/AppointmentController.getAvailableDoctors';

export default class VisitCreator extends NavigationMixin(LightningElement) {
    @track facilityId;
    @track specialization;
    @track doctorOptions = [];
    @track selectedDoctorId;
    @track selectedRecordTypeId;
    @track recordTypeOptions = [];
    @track specializationOptions = [];
    @track isLoading = false;

    @wire(getObjectInfo, { objectApiName: PERSON_OBJECT })
    personObjectInfo;

    @wire(getPicklistValues, { 
        recordTypeId: '$personObjectInfo.data.defaultRecordTypeId', 
        fieldApiName: SPECIALIZATION_FIELD 
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.specializationOptions = data.values.map(item => ({
                label: item.label, value: item.value
            }));
        }
    }

    @wire(getObjectInfo, { objectApiName: MEDICAL_APPOINTMENT_OBJECT })
    appointmentObjectInfo({ error, data }) {
        if (data) {
            const rtInfos = data.recordTypeInfos;
            this.recordTypeOptions = Object.keys(rtInfos)
                .filter(id => rtInfos[id].name !== 'Master' && rtInfos[id].available)
                .map(id => ({ label: rtInfos[id].name, value: id }));
            
            if (this.recordTypeOptions.length > 0) {
                this.selectedRecordTypeId = this.recordTypeOptions[0].value;
            }
        }
    }

    get isDoctorDisabled() {
        return !this.facilityId || !this.specialization;
    }

    handleFacilityChange(event) {
        this.facilityId = event.target.value;
        this.fetchDoctors();
    }

    handleSpecChange(event) {
        this.specialization = event.detail.value;
        this.fetchDoctors();
    }

    fetchDoctors() {
        if (this.facilityId && this.specialization) {
            this.isLoading = true;
            getAvailableDoctors({ facilityId: this.facilityId, specialization: this.specialization })
                .then(result => {
                    this.doctorOptions = result.map(doc => ({ label: doc.Name, value: doc.Id }));
                    this.selectedDoctorId = this.doctorOptions.length > 0 ? this.doctorOptions[0].value : null;
                })
                .catch(error => {
                    this.showToast('Błąd', 'Nie znaleziono lekarzy dla tej placówki', 'error');
                })
                .finally(() => { this.isLoading = false; });
        }
    }

    handleDoctorChange(event) {
        this.selectedDoctorId = event.detail.value;
    }

    handleRecordTypeChange(event) {
        this.selectedRecordTypeId = event.detail.value;
    }

    handleSubmit(event) {
        this.isLoading = true; 
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Doctor__c = this.selectedDoctorId;
        fields.RecordTypeId = this.selectedRecordTypeId;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleError(event) {
        this.isLoading = false;
        let message = 'Wystąpił błąd podczas zapisu.';
        if (event.detail && event.detail.detail) {
            message = event.detail.detail;
        } else if (event.detail && event.detail.message) {
            message = event.detail.message;
        }
        this.showToast('Validation Error', message, 'error');
    }

    handleSuccess() {
        this.isLoading = false;
        this.showToast('Sukces', 'Wizyta została utworzona', 'success');
        this.handleCancel();
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: { objectApiName: 'Medical_Appointment__c', actionName: 'list' },
            state: { filterName: 'Recent' }
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}