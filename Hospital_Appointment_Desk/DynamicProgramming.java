import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class DynamicProgramming {

    public static int maxAppointments(List<Appointment> appointments) {
        List<Appointment> sorted = new ArrayList<>(appointments);
        Collections.sort(sorted, Comparator.comparingInt(Appointment::getEndTime));

        int count = 0;
        int lastEndTime = -1;

        for (Appointment app : sorted) {
            if (app.getStartTime() >= lastEndTime) {
                count++;
                lastEndTime = app.getEndTime();
            }
        }
        return count;
    }
}
