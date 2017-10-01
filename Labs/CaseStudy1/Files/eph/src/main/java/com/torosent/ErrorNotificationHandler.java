package com.torosent;

import com.microsoft.azure.eventprocessorhost.ExceptionReceivedEventArgs;

import java.util.function.Consumer;

public class ErrorNotificationHandler implements Consumer<ExceptionReceivedEventArgs>
{
    public void accept(ExceptionReceivedEventArgs t)
    {
        // Handle the notification here
    }
}