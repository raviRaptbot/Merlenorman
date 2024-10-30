public class testqueueable implements Queueable
{
    public void execute(QueueableContext context) {
        // awesome code here

        HandleNextRunStartTime.setNextSearhFrom(DateTime.newInstance(2023, 11, 18, 3, 3, 3));
    }
}