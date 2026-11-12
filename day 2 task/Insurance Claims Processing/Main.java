import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Claim> claims = loadClaims("claims.csv");
        System.out.println("Loaded " + claims.size() + " claims from CSV.");

        System.out.println("\n--- Task 1: BST Operations & Traversals ---");
        ClaimBST bst = new ClaimBST();
        int[] sampleIds = {5045, 5015, 5075, 5006, 5030, 5060, 5090};
        for (int id : sampleIds) {
            bst.insert(id);
        }
        System.out.println("Search 5030: " + bst.search(5030));
        System.out.println("Search 9999: " + bst.search(9999));
        bst.inorder();
        bst.preorder();
        bst.postorder();

        System.out.println("\n--- Task 2: Duplicate & Near-Duplicate Claim Detection ---");
        DuplicateDetector.detectDuplicates(claims);
        System.out.println("Empty Input Test:");
        DuplicateDetector.detectDuplicates(Collections.emptyList());

        System.out.println("\n--- Task 3: Claim Approval Stages Graph (BFS & DFS) ---");
        ApprovalGraph workflow = new ApprovalGraph();
        workflow.addStageTransition("Registration", "Assessment");
        workflow.addStageTransition("Assessment", "Surveyor");
        workflow.addStageTransition("Surveyor", "Settlement");
        workflow.addStageTransition("Registration", "Surveyor");

        System.out.println("Shortest Path (Registration -> Settlement): " + workflow.shortestPath("Registration", "Settlement"));
        System.out.println("Cycle Detected (Before loop): " + workflow.hasCycle());

        workflow.addStageTransition("Surveyor", "Assessment");
        System.out.println("Cycle Detected (After adding Surveyor -> Assessment): " + workflow.hasCycle());

        System.out.println("\n--- Task 4: Longest Spike Run (> 100 Claims) ---");
        int[] dailyCounts = {85, 110, 125, 140, 95, 105, 115, 130, 150, 90};
        System.out.println("Longest consecutive days > 100: " + SpikeMonitor.longestSpikeRun(dailyCounts, 100));
        System.out.println("Empty Array Test: " + SpikeMonitor.longestSpikeRun(new int[]{}, 100));

        System.out.println("\n--- Task 5: Two-Pointer Merge of Sorted Regional Claims ---");
        List<Claim> northClaims = new ArrayList<>();
        List<Claim> southClaims = new ArrayList<>();
        for (Claim c : claims) {
            if ("North".equalsIgnoreCase(c.getRegion())) {
                northClaims.add(c);
            } else {
                southClaims.add(c);
            }
        }
        northClaims.sort(Comparator.comparingInt(Claim::getClaimId));
        southClaims.sort(Comparator.comparingInt(Claim::getClaimId));

        List<Claim> merged = ClaimMerger.mergeSortedLists(northClaims, southClaims);
        System.out.println("North size: " + northClaims.size() + " | South size: " + southClaims.size() + " | Merged size: " + merged.size());
        System.out.println("Empty Lists Merge Test size: " + ClaimMerger.mergeSortedLists(Collections.emptyList(), Collections.emptyList()).size());
    }

    private static List<Claim> loadClaims(String filename) {
        List<Claim> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line = br.readLine();
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 5) {
                    int cid = Integer.parseInt(parts[0].trim());
                    String pol = parts[1];
                    String dt = parts[2];
                    double amt = Double.parseDouble(parts[3].trim());
                    String reg = parts[4].trim();
                    list.add(new Claim(cid, pol, dt, amt, reg));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }
}
