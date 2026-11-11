public class Patient {
    private int patientId;
    private String name;
    private int urgency;
    private int arrivalTime;
    private int slot;
    private String doctorId;

    public Patient(int patientId, String name, int urgency, int arrivalTime, int slot, String doctorId) {
        this.patientId = patientId;
        this.name = name;
        this.urgency = urgency;
        this.arrivalTime = arrivalTime;
        this.slot = slot;
        this.doctorId = doctorId;
    }

    public int getPatientId() {
        return patientId;
    }

    public String getName() {
        return name;
    }

    public int getUrgency() {
        return urgency;
    }

    public int getArrivalTime() {
        return arrivalTime;
    }

    public int getSlot() {
        return slot;
    }

    public String getDoctorId() {
        return doctorId;
    }

    @Override
    public String toString() {
        return "ID: " + patientId + ", Name: " + name + ", Urgency: " + urgency + ", Arrival: " + arrivalTime + "m, Slot: " + slot;
    }
}
