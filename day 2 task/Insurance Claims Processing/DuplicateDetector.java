import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class DuplicateDetector {

    private static String normalize(String input) {
        if (input == null) {
            return "";
        }
        return input.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
    }

    public static void detectDuplicates(List<Claim> claims) {
        if (claims == null || claims.isEmpty()) {
            System.out.println("No claims provided for duplicate check.");
            return;
        }

        Map<String, LinkedList<Claim>> hashTable = new HashMap<>();

        for (Claim claim : claims) {
            String key = normalize(claim.getPolicyNumber()) + "_" + normalize(claim.getIncidentDate());
            hashTable.putIfAbsent(key, new LinkedList<>());
            LinkedList<Claim> bucket = hashTable.get(key);

            if (!bucket.isEmpty()) {
                System.out.println("Duplicate/Near-Duplicate Detected for Key [" + key + "]:");
                System.out.println("  Original : " + bucket.getFirst());
                System.out.println("  Duplicate: " + claim);
            }
            bucket.add(claim);
        }
    }
}
