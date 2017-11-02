using Microsoft.WindowsAzure.Storage.Table;

public class StatusEntity : TableEntity
{
    public StatusEntity()
    {
        this.PartitionKey = "status";
        this.RowKey = "name";
    }

    public string Message { get; set; }
}