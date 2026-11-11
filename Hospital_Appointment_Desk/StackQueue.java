public class StackQueue {

    public static class CustomQueue {
        private Patient[] array;
        private int front;
        private int rear;
        private int size;
        private int capacity;

        public CustomQueue(int capacity) {
            this.capacity = capacity;
            this.array = new Patient[capacity];
            this.front = 0;
            this.rear = -1;
            this.size = 0;
        }

        public void enqueue(Patient item) {
            if (size == capacity) return;
            rear = (rear + 1) % capacity;
            array[rear] = item;
            size++;
        }

        public Patient dequeue() {
            if (size == 0) return null;
            Patient item = array[front];
            front = (front + 1) % capacity;
            size--;
            return item;
        }

        public int getSize() {
            return size;
        }
    }

    public static class CustomStack {
        private Patient[] array;
        private int top;
        private int capacity;

        public CustomStack(int capacity) {
            this.capacity = capacity;
            this.array = new Patient[capacity];
            this.top = -1;
        }

        public void push(Patient item) {
            if (top == capacity - 1) return;
            array[++top] = item;
        }

        public Patient pop() {
            if (top == -1) return null;
            return array[top--];
        }

        public int getSize() {
            return top + 1;
        }
    }
}
