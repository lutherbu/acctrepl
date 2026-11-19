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

# Five-calendar-year pooled extension of each authored plot window.
long_original_end <- as.Date("2019-06-30")
long_requested_end <- as.Date("2024-06-30")
long_dates <- as.Date(XRP$DATE)
long_original <- long_dates > as.Date("2019-03-28") & long_dates <= long_original_end
long_added <- long_dates > long_original_end & long_dates <= long_requested_end
long_original_n <- sum(long_original)
long_added_n <- sum(long_added)
long_last_added <- if (long_added_n > 0L) format(max(long_dates[long_added])) else "NA"
cat("EXT_SAMPLE xrp_long", long_original_n, long_added_n, long_last_added, "\n")

#long version
XRP = XRP[as.Date(XRP$DATE)<as.Date("2024-07-01"),]
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
if (!dir.exists("../outputs")) dir.create("../outputs", recursive = TRUE)
ggplot2::ggsave("../outputs/xrp_transfers_long.pdf", plot = p_long, width = 7, height = 7, units = "in", device = "pdf")


#short version  
short_original_end <- as.Date("2019-05-30")
short_requested_end <- as.Date("2024-05-30")
short_dates <- as.Date(DF$Date)
short_original <- short_dates > as.Date("2019-03-28") & short_dates <= short_original_end
short_added <- short_dates > short_original_end & short_dates <= short_requested_end
short_original_n <- sum(short_original)
short_added_n <- sum(short_added)
short_last_added <- if (short_added_n > 0L) format(max(short_dates[short_added])) else "NA"
cat("EXT_SAMPLE xrp_short", short_original_n, short_added_n, short_last_added, "\n")

X = DF[as.Date(DF$Date)<as.Date("2024-06-01"),]
X = X[as.Date(X$Date)<as.Date("2024-05-31"),]
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

extension_summary <- data.frame(
  key = c("xrp_long", "xrp_short"),
  count_unit = c("daily grouped dates plotted", "daily source rows plotted (one row per date)"),
  original_n = c(long_original_n, short_original_n),
  added_n = c(long_added_n, short_added_n),
  original_end = c(format(long_original_end), format(short_original_end)),
  requested_end = c(format(long_requested_end), format(short_requested_end)),
  supported_end = rep(format(max(valid_dates)), 2),
  last_added = c(long_last_added, short_last_added)
)
write.csv(extension_summary, "../outputs/xrp_extension_summary.csv", row.names = FALSE)
