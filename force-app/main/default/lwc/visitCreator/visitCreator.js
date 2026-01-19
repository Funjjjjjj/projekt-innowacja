import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import MEDICAL_APPOINTMENT_OBJECT from '@salesforce/schema/Medical_Appointment__c'; 
import getAvailableDoctors from '@salesforce/apex/AppointmentController.getAvailableDoctors';

export default class VisitCreator extends NavigationMixin(LightningElement) {
    @track facilityId;
    @track specialization;
    @track doctorOptions = [];
    @track selectedDoctorId;
    @track selectedRecordTypeId;
    @track recordTypeOptions = [];
    @wire(getObjectInfo, { objectApiName: MEDICAL_APPOINTMENT_OBJECT })
    objectInfo({ error, data }) {
        if (data) {
            const rtInfos = data.recordTypeInfos;
            // Filtrujemy, aby nie pokazywać technicznego typu "Master"
            this.recordTypeOptions = Object.keys(rtInfos)
                .filter(id => rtInfos[id].name !== 'Master' && rtInfos[id].available)
                .map(id => ({ label: rtInfos[id].name, value: id }));
            
            if (this.recordTypeOptions.length > 0) {
                this.selectedRecordTypeId = this.recordTypeOptions[0].value;
            }
        } else if (error) {
            console.error('Błąd Record Types:', error);
        }
    }

    // Te opcje muszą odpowiadać wartościom specjalizacji u Twoich lekarzy
    get specializationOptions() {
        return [
            { label: 'Internista', value: 'Internist' },
            { label: 'Kardiolog', value: 'Cardiologist' },
            { label: 'Alergolog', value: 'Allergist' },
            { label: 'Laryngolog', value: 'Laryngologist' }
        ];
    }

    get isDoctorDisabled() {
        return !this.facilityId || !this.specialization;
    }
    handleRecordTypeChange(event) {
        this.selectedRecordTypeId = event.detail.value;
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
        // Logika uruchomi się tylko gdy oba pola są wybrane
        if (this.facilityId && this.specialization) {
            getAvailableDoctors({ facilityId: this.facilityId, specialization: this.specialization })
                .then(result => {
                    this.doctorOptions = result.map(doc => ({ label: doc.Name, value: doc.Id }));
                    if (this.doctorOptions.length > 0) {
                        this.selectedDoctorId = this.doctorOptions[0].value;
                    } else {
                        this.selectedDoctorId = null;
                    }
                })
                .catch(error => {
                    console.error('Błąd pobierania lekarzy:', error);
                });
        }
    }

    handleDoctorChange(event) {
        this.selectedDoctorId = event.detail.value;
    }

    handleSubmit(event) {
        event.preventDefault(); 
        const fields = event.detail.fields; 
        
        // PRZYPISANIE WYBRANEGO LEKARZA I TYPU REKORDU
        fields.Doctor__c = this.selectedDoctorId; 
        fields.RecordTypeId = this.selectedRecordTypeId; // DODAJ TĘ LINIĘ
        
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Sukces',
            message: 'Wizyta została utworzona pomyślnie',
            variant: 'success'
        }));
        this.handleCancel();
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Medical_Appointment__c',
                actionName: 'list'
            },
            state: { filterName: 'Recent' }
        });
    }
}