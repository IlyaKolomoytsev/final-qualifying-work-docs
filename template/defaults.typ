#let default-ministry = [Министерство науки и высшего образования Российской Федерации]
#let default-university = {
let rows = (
[Федеральное государственное бюджетное образовательное учреждение],
[высшего образования],
[«Волгоградский государственный технический университет»],
)
  (
    full: rows.join(" "),
    rows: rows,
    short: [ВолгГТУ]
  )
}
#let default-university-president = [Профессору д.х.н. Навроцкому А.В.]
#let default-faculty = (full: [Электроники и вычислительной техники], short: [ФЭВТ])
#let default-department = [Программное обеспечение автоматизированных систем]
#let default-program = (code: [09.03.04], name: [Программная инженерия])
#let default-type-of-program = [очное]
#let default-city = [Волгоград]
#let default-plagiarism-detection-system = [Антиплагиат]
