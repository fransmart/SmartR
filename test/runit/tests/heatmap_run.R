source("web-app/HeimScripts/heatmap/run.R")

# Test slash being removed - issue that used to broke sorting
test.fixString.slash.case <- function()
{
  testString <- "a/b"
  result <- fixString(testString)
  expected <- "ab"
  checkEquals(result,expected)
}

#Dashes are allowed in probe_ids
test.fixString.dash.case <- function()
{
  testString <- "a-b"
  result <- fixString(testString)
  expected <- "a-b"
  checkEquals(result,expected)
}

test.mergeFetchedData.singledf <- function()
{
  df1 <- data.frame(Row.Label=c("a1","a2","b1","b2") , Bio.marker= c("a","a","b","b"), Assay1 = 1:4, Assay2 = 4:1  )
  test_loaded_variables <- list(d1=df1)
  result <- mergeFetchedData(test_loaded_variables)
  expected <- data.frame(Row.Label=c("a1","a2","b1","b2") , Bio.marker= c("a","a","b","b"), Assay1_d1 = 1:4, Assay2_d1 = 4:1  )
  checkEquals(result,expected)
}

test.mergeFetchedData.twodfs <- function()
{
  df1 <- data.frame(Row.Label=c("a1","a2","b1","b2") , Bio.marker= c("a","a","b","b"), Assay1 = 1:4, Assay2 = 4:1  )
  df2 <- data.frame(Row.Label=c("a1","a2","b1","b2") , Bio.marker= c("a","a","b","b"), Assay3 = 1:4, Assay4 = 4:1  )
  test_loaded_variables <- list(d1=df1, d2=df2)
  merged <- mergeFetchedData(test_loaded_variables)
  checkTrue(all(colnames(merged) == c("Row.Label","Bio.marker","Assay1_d1","Assay2_d1","Assay3_d2","Assay4_d2")))
  checkTrue(nrow(merged) == 4)
}

test.get.subset <- function()
{
  test_patient_ids <- c("Assay1_blabla_s1","Assay2_bleblee_s2")
  result <- getSubset(test_patient_ids)
  expected <- c(1,2)
  checkEquals(result, expected)
}

test.get.subject <- function()
{
  test_patient_ids <- c("wk26_16702_n0_s1", "wk26_16705_n1_s1", "wk26_16707_n0_s1", "wk52_16710_n0_s2")
  result <- getSubject(test_patient_ids)
  expected <- c("wk26_16702", "wk26_16705", "wk26_16707", "wk52_16710")
  checkEquals(result, expected)
}

test.getSubset1Length <- function()
{
  testMeasurements <- data.frame("a_n0_s1" = 1:3,
   "b_n0_s1" = 1:3, "a_n1_s1" = 1:3, "b_n1_s1" = 1:3,
   "a_n0_s2" = 1:3, "b_n0_s2" = 1:3 )
  expected <- 4
  result   <- getSubset1Length(testMeasurements)
  checkEquals(result,expected)
}

test.getDesign <- function()
{
  testMeasurements <- data.frame("a_n0_s1" = 1:3,
     "b_n0_s1" = 1:3, "a_n1_s1" = 1:3, "b_n1_s1" = 1:3,
     "a_n0_s2" = 1:3, "b_n0_s2" = 1:3 )
  expected <- matrix(
    c(1, 1, 1, 1, 2, 2, 
      2, 2, 2, 2, 1, 1),
    ncol = 2
   )
  colnames(expected) <- c("S1", "S2")
  result             <- getDesign(testMeasurements)
  checkEquals(result,expected)
}

test.getDEgenes <- function()
{
  test_set<- data.frame( Row.Label = c("1007_s_at", "1053_at", "117_at"),
                         Bio.marker = c("a", "b", "c"),
                         GSM210004_n0_s1 = c(6.5, 4, 5),
                         GSM210006_n1_s1 = c(8.1, 2, 4),
                         GSM210007_n1_s1 = c(6.2, 3, 5),
                         GSM210008_n1_s1 = c(8.34, 2, 5),
                         GSM210006_n1_s2 = c(8.4, -2, 9),
                         GSM210007_n1_s2 = c(6.4,2, 12),
                         stringsAsFactors = F)
  result <- getDEgenes(test_set)
  result[,-c(1,2)]<-round(result[,-c(1,2)],4)
  
  expected <- data.frame( Row.Label = c("1007_s_at", "1053_at", "117_at"),
                          Bio.marker = c("a", "b", "c"),
                          logfold = c(0.115, -2.75, 5.75),
                          ttest = c(0.089, -2.1275, 4.4485),
                          pval = c(0.9306, 0.0548, 0.0008),
                          adjpval = c(0.9306, 0.0822, 0.0024),
                          bval = c(-5.7709, -3.7252, 3.1846),
                          stringsAsFactors = F)
  checkEquals(result, expected)
}
