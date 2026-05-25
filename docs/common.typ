#let topic-of-work = [
  Компьютерное моделирование программно-аппаратных гидроакустических приёмопередатчиков
  для их виртуальных испытаний
]

#let author-full = [Коломойцев Илья Сергеевич]
#let author-short = [Коломойцев И. С.]
#let reverse-autrho-short = [И. С. Коломойцев]
#let author-group = [ПрИн-466]

#let scientific-supervisor-full = [Матюшечкин Дмитрий Сергеевич]
#let scientific-supervisor-short = [Матюшечкин Д. С.]
#let reverse-scientific-supervisor-short = [Д. С. Матюшечкин]
#let scientific-degree = [к.т.н.]

#let approver-status = [и. о. зав. кафедрой]
#let approver-full = [Сычёв Олег Александрович]
#let approver-short = [Сычёв О. А.]
#let reverse-approver-short = [О. А. Сычёв]

#let compliance-officer-full = [Кузнецова Агнесса Сергеевна]
#let compliance-officer-short = [Кузнецова А. С.]
#let reverse-compliance-officer-short = [А. С. Кузнецова]

#let year = datetime.today().year()

#import "../template/title-pages/explanatory-note.typ": explanatory-note-title-page
#let explanatory-note-title = explanatory-note-title-page(
  approval-position: approver-status,
  approval-name: reverse-approver-short,
  topic: topic-of-work,
  author: author-full,
  document-code: [ВКРБ-09.03.04-10.19-03-26],
  group: author-group,
  supervisor: scientific-supervisor-short,
  norm-controller: compliance-officer-short,
  year: 2005
)

#explanatory-note-title
