
public class ZerosToend {
    public static void main(String[] args) {

        int[] a = {1, 2, 3, 4, 0, 5, 7, 0, 1};

        int i = 0, j = 0, temp;

        for (i = 0; i < a.length; i++) {

            if (a[i] != 0) {

                temp = a[i];
                a[i] = a[j];
                a[j] = temp;

                j++;
            }
        }

        for (i = 0; i < a.length; i++) {
            System.out.print(a[i] + " ");
        }
    }
}
