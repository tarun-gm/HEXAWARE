import java.util.List;

public class Searching {

    public static Patient linearSearch(List<Patient> patients, int targetId) {
        for (Patient p : patients) {
            if (p.getPatientId() == targetId) {
                return p;
            }
        }
        return null;
    }

    public static Patient binarySearch(List<Patient> patients, int targetId) {
        int low = 0;
        int high = patients.size() - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;
            int midId = patients.get(mid).getPatientId();

            if (midId == targetId) {
                return patients.get(mid);
            } else if (midId < targetId) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return null;
    }
}
