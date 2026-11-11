import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class DuplicateDetection {

    public static void findDuplicates(List<Patient> patients) {
        Set<String> seen = new HashSet<>();
        Set<String> duplicates = new HashSet<>();

        for (Patient p : patients) {
            String key = p.getPatientId() + "-" + p.getSlot();
            if (seen.contains(key)) {
                duplicates.add(key);
            } else {
                seen.add(key);
            }
        }

        System.out.println("Double-booked slots detected (PatientID-Slot): " + duplicates.size());
        for (String d : duplicates) {
            System.out.println("  Duplicate booking: " + d);
        }
    }
}
