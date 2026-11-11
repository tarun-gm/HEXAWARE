import java.util.List;

public class Sorting {
    public static long selectionSortSwaps = 0;
    public static long quickSortSwaps = 0;

    public static void selectionSort(List<Patient> list) {
        selectionSortSwaps = 0;
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            int maxIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (compare(list.get(j), list.get(maxIdx)) > 0) {
                    maxIdx = j;
                }
            }
            if (maxIdx != i) {
                Patient temp = list.get(i);
                list.set(i, list.get(maxIdx));
                list.set(maxIdx, temp);
                selectionSortSwaps++;
            }
        }
    }

    public static void quickSort(List<Patient> list, int low, int high) {
        if (low == 0 && high == list.size() - 1) {
            quickSortSwaps = 0;
        }
        if (low < high) {
            int pi = partition(list, low, high);
            quickSort(list, low, pi - 1);
            quickSort(list, pi + 1, high);
        }
    }

    private static int partition(List<Patient> list, int low, int high) {
        Patient pivot = list.get(high);
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (compare(list.get(j), pivot) >= 0) {
                i++;
                Patient temp = list.get(i);
                list.set(i, list.get(j));
                list.set(j, temp);
                quickSortSwaps++;
            }
        }
        Patient temp = list.get(i + 1);
        list.set(i + 1, list.get(high));
        list.set(high, temp);
        quickSortSwaps++;
        return i + 1;
    }

    private static int compare(Patient p1, Patient p2) {
        if (p1.getUrgency() != p2.getUrgency()) {
            return Integer.compare(p1.getUrgency(), p2.getUrgency());
        }
        return Integer.compare(p2.getArrivalTime(), p1.getArrivalTime());
    }
}
