public class ClaimBST {
    private static class Node {
        int claimId;
        Node left;
        Node right;

        Node(int claimId) {
            this.claimId = claimId;
        }
    }

    private Node root;

    public void insert(int claimId) {
        root = insertRec(root, claimId);
    }

    private Node insertRec(Node current, int claimId) {
        if (current == null) {
            return new Node(claimId);
        }
        if (claimId < current.claimId) {
            current.left = insertRec(current.left, claimId);
        } else if (claimId > current.claimId) {
            current.right = insertRec(current.right, claimId);
        }
        return current;
    }

    public boolean search(int claimId) {
        return searchRec(root, claimId);
    }

    private boolean searchRec(Node current, int claimId) {
        if (current == null) {
            return false;
        }
        if (claimId == current.claimId) {
            return true;
        }
        return claimId < current.claimId
                ? searchRec(current.left, claimId)
                : searchRec(current.right, claimId);
    }

    public void inorder() {
        System.out.print("Inorder: ");
        inorderRec(root);
        System.out.println();
    }

    private void inorderRec(Node node) {
        if (node != null) {
            inorderRec(node.left);
            System.out.print(node.claimId + " ");
            inorderRec(node.right);
        }
    }

    public void preorder() {
        System.out.print("Preorder: ");
        preorderRec(root);
        System.out.println();
    }

    private void preorderRec(Node node) {
        if (node != null) {
            System.out.print(node.claimId + " ");
            preorderRec(node.left);
            preorderRec(node.right);
        }
    }

    public void postorder() {
        System.out.print("Postorder: ");
        postorderRec(root);
        System.out.println();
    }

    private void postorderRec(Node node) {
        if (node != null) {
            postorderRec(node.left);
            postorderRec(node.right);
            System.out.print(node.claimId + " ");
        }
    }
}
