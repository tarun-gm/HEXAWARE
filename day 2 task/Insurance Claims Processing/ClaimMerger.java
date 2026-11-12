import java.util.ArrayList;
import java.util.List;

public class ClaimMerger {

    public static List<Claim> mergeSortedLists(List<Claim> list1, List<Claim> list2) {
        List<Claim> merged = new ArrayList<>();
        if (list1 == null && list2 == null) {
            return merged;
        }
        if (list1 == null) {
            merged.addAll(list2);
            return merged;
        }
        if (list2 == null) {
            merged.addAll(list1);
            return merged;
        }

        int i = 0;
        int j = 0;

        while (i < list1.size() && j < list2.size()) {
            if (list1.get(i).getClaimId() <= list2.get(j).getClaimId()) {
                merged.add(list1.get(i));
                i++;
            } else {
                merged.add(list2.get(j));
                j++;
            }
        }

        while (i < list1.size()) {
            merged.add(list1.get(i));
            i++;
        }

        while (j < list2.size()) {
            merged.add(list2.get(j));
            j++;
        }

        return merged;
    }
}
