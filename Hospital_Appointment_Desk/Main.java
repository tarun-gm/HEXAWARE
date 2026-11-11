import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        List<Patient> patients = loadPatients("patients.csv");
        System.out.println("Loaded " + patients.size() + " patient records.");

        patients.sort(Comparator.comparingInt(Patient::getPatientId));

        System.out.println("\n--- Task 1: Linear vs Binary Search Performance ---");
        Random rand = new Random();
        int[] targetIds = new int[1000];
        for (int i = 0; i < 1000; i++) {
            targetIds[i] = patients.get(rand.nextInt(patients.size())).getPatientId();
        }

        long startLinear = System.nanoTime();
        for (int id : targetIds) {
            Searching.linearSearch(patients, id);
        }
        long endLinear = System.nanoTime();
        double linearTimeMs = (endLinear - startLinear) / 1e6;

        long startBinary = System.nanoTime();
        for (int id : targetIds) {
            Searching.binarySearch(patients, id);
        }
        long endBinary = System.nanoTime();
        double binaryTimeMs = (endBinary - startBinary) / 1e6;

        System.out.println("Time for 1,000 Linear Searches: " + String.format("%.2f", linearTimeMs) + " ms");
        System.out.println("Time for 1,000 Binary Searches: " + String.format("%.2f", binaryTimeMs) + " ms");

        System.out.println("\n--- Task 2: Selection Sort vs Quick Sort ---");
        List<Patient> sampleForSort1 = new ArrayList<>(patients.subList(0, 1000));
        List<Patient> sampleForSort2 = new ArrayList<>(sampleForSort1);

        long startSel = System.currentTimeMillis();
        Sorting.selectionSort(sampleForSort1);
        long endSel = System.currentTimeMillis();

        long startQuick = System.currentTimeMillis();
        Sorting.quickSort(sampleForSort2, 0, sampleForSort2.size() - 1);
        long endQuick = System.currentTimeMillis();

        System.out.println("Selection Sort Time: " + (endSel - startSel) + " ms | Swaps: " + Sorting.selectionSortSwaps);
        System.out.println("Quick Sort Time: " + (endQuick - startQuick) + " ms | Swaps: " + Sorting.quickSortSwaps);

        System.out.println("\n--- Task 3: Double-Booked Slot Detection ---");
        DuplicateDetection.findDuplicates(patients);

        System.out.println("\n--- Task 4: Walk-in Queue & Patient Stack ---");
        StackQueue.CustomQueue walkInQueue = new StackQueue.CustomQueue(100);
        StackQueue.CustomStack viewStack = new StackQueue.CustomStack(100);

        for (int i = 0; i < 5; i++) {
            walkInQueue.enqueue(patients.get(i));
            viewStack.push(patients.get(i));
        }
        System.out.println("Queue size: " + walkInQueue.getSize() + " | Stack size: " + viewStack.getSize());

        System.out.println("\n--- Task 5: Max Non-Overlapping Appointments (DP / Greedy) ---");
        List<Appointment> docAppointments = new ArrayList<>();
        docAppointments.add(new Appointment(900, 930));
        docAppointments.add(new Appointment(915, 945));
        docAppointments.add(new Appointment(930, 1000));
        docAppointments.add(new Appointment(945, 1030));
        docAppointments.add(new Appointment(1000, 1030));

        int maxApps = DynamicProgramming.maxAppointments(docAppointments);
        System.out.println("Max appointments doctor can attend: " + maxApps);
    }

    private static List<Patient> loadPatients(String filename) {
        List<Patient> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line = br.readLine();
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 6) {
                    int pid = Integer.parseInt(parts[0]);
                    String name = parts[1];
                    int urgency = Integer.parseInt(parts[2]);
                    int arrival = Integer.parseInt(parts[3]);
                    int slot = Integer.parseInt(parts[4]);
                    String docId = parts[5];
                    list.add(new Patient(pid, name, urgency, arrival, slot, docId));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }
}
