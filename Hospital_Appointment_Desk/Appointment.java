public class Appointment {
    private int startTime;
    private int endTime;

    public Appointment(int startTime, int endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getStartTime() {
        return startTime;
    }

    public int getEndTime() {
        return endTime;
    }

    @Override
    public String toString() {
        return "[" + startTime + " - " + endTime + "]";
    }
}
