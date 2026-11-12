public class SpikeMonitor {

    public static int longestSpikeRun(int[] dailyClaims, int threshold) {
        if (dailyClaims == null || dailyClaims.length == 0) {
            return 0;
        }

        int maxRun = 0;
        int windowStart = 0;

        for (int windowEnd = 0; windowEnd < dailyClaims.length; windowEnd++) {
            if (dailyClaims[windowEnd] <= threshold) {
                windowStart = windowEnd + 1;
            } else {
                int currentLength = windowEnd - windowStart + 1;
                if (currentLength > maxRun) {
                    maxRun = currentLength;
                }
            }
        }
        return maxRun;
    }
}
