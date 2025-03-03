# pROC package
ggplot(data = Res, aes(x = recall, y = precision, color = signature)) +
  geom_line() +
  geom_point(data = Best2, inherit.aes = FALSE, aes(x=recall, y=precision, color=signature, shape = score_type, size = 1)) +
  scale_shape_manual(values = c(2, 6)) +
  scale_color_manual(values = SigColor) +
  labs(x = "Recall", y = "Precision", title = "Precision-Recall Curve by max Clone Scores")



# ROCR package

pred <- prediction( ROCR.simple$predictions, ROCR.simple$labels)
fscore <- 2*(res$precision * res$recall) / (res$precision + res$recall)
  
  res <- res %>% left_join(fscore)
  
  bestF <- max(fscore) %>% mutate(signature = sigName)
  bestAUC <- coords(rocObj, "best", ret = "all", transpose = FALSE) %>%
    right_join(bestF)
  
  ci <- pROC::ci(rocObj, of = "auc")
  names(ci) <- c("CI95%low", "AUC", "CI95%high")
  ci$signature <- sigName
  ci <- as.data.frame(ci) %>% select(signature, 1:3)
  
  l <- list(res, bestF, bestAUC, ci)
  names(l) <- c("result", "best_Fscore", "best_AUCscore", "ciAUC")perf <- performance(pred,"tpr","fpr")
plot(perf,
     avg="threshold",
     spread.estimate="boxplot")

perf2 <- performance(pred, "prec", "rec")
plot(perf2,
     avg= "threshold",
     colorize=TRUE,
     lwd= 3,
     main= "... Precision/Recall graphs ...")
plot(perf2,
     lty=3,
     col="grey78",
     add=TRUE)

perf3 <- performance(pred, "sens", "spec")
plot(perf3,
     avg= "threshold",
     colorize=TRUE,
     lwd= 3,
     main="... Sensitivity/Specificity plots ...")
plot(perf3,
     lty=3,
     col="grey78",
     add=TRUE)

perf4 <- performance(pred, "lift", "rpp")
plot(perf4,
     avg= "threshold",
     colorize=TRUE,
     lwd= 3,
     main= "... and Lift charts.")
plot(perf4,
     lty=3,
     col="grey78",
     add=TRUE)



data(ROCR.xval)
predictions <- ROCR.xval$predictions
labels <- ROCR.xval$labels
length(predictions)


# pROC package
plot(precision ~ recall, 
     coords(trtpred, "all", ret = c("recall", "precision"), transpose = FALSE),
     type="l", ylim = c(0, 100))

plot(specificity + sensitivity ~ threshold, 
     coords(crov, "all", transpose = FALSE), 
     type = "l", log="x", 
     subset = is.finite(threshold))

plot(tpr ~ fpr, 
     coords(crov, "all", ret = c("tpr", "fpr"), transpose = FALSE),
     type="l")

coords(crov, "best", ret="threshold", transpose = FALSE, 
       best.method="closest.topleft", best.weights=c(0.1, 0.2))

plot(crov, print.thres="best", print.thres.best.method="closest.topleft",
     print.thres.best.weights=c(0.5, 0.2)) 


# Get the coordinates of S100B threshold 0.306102443
coords(crov, 0.306102443, transpose = FALSE)

# Get the coordinates at 30% sensitivity
coords(roc=crov, x=0.3, input="sensitivity", transpose = FALSE)



