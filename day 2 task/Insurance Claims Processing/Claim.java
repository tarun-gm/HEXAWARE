public class Claim {
    private int claimId;
    private String policyNumber;
    private String incidentDate;
    private double amount;
    private String region;

    public Claim(int claimId, String policyNumber, String incidentDate, double amount, String region) {
        this.claimId = claimId;
        this.policyNumber = policyNumber;
        this.incidentDate = incidentDate;
        this.amount = amount;
        this.region = region;
    }

    public int getClaimId() {
        return claimId;
    }

    public String getPolicyNumber() {
        return policyNumber;
    }

    public String getIncidentDate() {
        return incidentDate;
    }

    public double getAmount() {
        return amount;
    }

    public String getRegion() {
        return region;
    }

    @Override
    public String toString() {
        return "Claim[ID=" + claimId + ", Policy=" + policyNumber + ", Date=" + incidentDate + ", Amount=" + amount + ", Region=" + region + "]";
    }
}
