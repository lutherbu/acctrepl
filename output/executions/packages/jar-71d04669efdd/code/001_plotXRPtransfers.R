#plot
setwd("Figures")
require(readxl)
DF = withCallingHandlers(
  as.data.frame(read_excel("Figure 3 Data.xlsx", sheet = 1), check.names = FALSE),
  warning = function(w) stop("Workbook import emitted a warning: ", conditionMessage(w), call. = FALSE)
)
stopifnot(identical(names(DF), c("Date", "Out", "In", "Total")))
stopifnot(inherits(DF$Date, "Date") || inherits(DF$Date, "POSIXt"))
date_check <- as.Date(DF$Date)
stopifnot(identical(is.na(date_check), is.na(DF$Date)))
valid_dates <- date_check[!is.na(date_check)]
stopifnot(length(valid_dates) > 0L)
stopifnot(all(vapply(DF[c("Total", "In", "Out")], is.numeric, logical(1))))
classes <- vapply(DF, function(x) paste(class(x), collapse = "/"), character(1))
cat("FIG3_COLUMNS_CLASSES:", paste(paste(names(DF), classes, sep = "="), collapse = ";"), "\n")
cat("FIG3_ROWS:", nrow(DF), "\n")
cat("FIG3_DATE_COVERAGE:", format(min(valid_dates)), "through", format(max(valid_dates)), "\n")

require(data.table) #agregated daily
XRP = data.table(DF)
XRP = XRP[, list(TRANSFER = sum(Total,na.rm=TRUE),
             IN = sum(In,na.rm=TRUE),
             OUT = sum(Out,na.rm=TRUE)), 
       by = list(DATE = Date)]

#long version
XRP = XRP[as.Date(XRP$DATE)<as.Date("2019-07-01"),]
XRP = XRP[as.Date(XRP$DATE)>as.Date("2019-03-28"),]

require(ggplot2) #plots
p_long <- ggplot() + 
  geom_bar(mapping = aes(x = as.Date(XRP$DATE), y = XRP$TRANSFER), stat = "identity", fill = "black") +
  geom_bar(mapping = aes(x = as.Date(XRP$DATE), y = XRP$IN), stat = "identity", fill = "blue") +
  geom_bar(mapping = aes(x = as.Date(XRP$DATE), y = XRP$OUT), stat = "identity", fill = "red") +
  theme_bw()+
  theme(
    axis.title.y = element_text(color = "grey"),
    axis.title.y.right = element_text(color = "red"),
    axis.ticks.y.right = element_line(color="red"),
    axis.text.y.right = element_text(color="red"),
  )
ggplot2::ggsave("../outputs/xrp_transfers_long.pdf", plot = p_long, width = 7, height = 7, units = "in", device = "pdf")


#short version  
X = DF[as.Date(DF$Date)<as.Date("2019-06-01"),]
X = X[as.Date(X$Date)<as.Date("2019-05-31"),]
X = X[as.Date(X$Date)>as.Date("2019-03-28"),]

#plots
p_short <- ggplot() + 
  geom_bar(mapping = aes(x = as.Date(X$Date), y = X$Total), stat = "identity", fill = "black") +
  geom_bar(mapping = aes(x = as.Date(X$Date), y = X$In), stat = "identity", fill = "blue") +
  geom_bar(mapping = aes(x = as.Date(X$Date), y = X$Out), stat = "identity", fill = "red") +
  theme_bw()+
  theme(
    axis.title.y = element_text(color = "grey"),
    axis.title.y.right = element_text(color = "red"),
    axis.ticks.y.right = element_line(color="red"),
    axis.text.y.right = element_text(color="red"),
  )
ggplot2::ggsave("../outputs/xrp_transfers_short.pdf", plot = p_short, width = 7, height = 7, units = "in", device = "pdf")
