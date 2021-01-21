# Reward System
Implement a system for calculating rewards based
on recommendations of customers.

## Concept
A company is planning a way to reward customers
for inviting their friends. They're planning a
reward system that will give a customer points
for each confirmed invitation they played a
part into. The definition of a confirmed
invitation is one where an invited person
accepts their contract. Inviters also should be
rewarded when someone they have invited invites
more people.

The inviter gets (1/2)^k points for each
confirmed invitation, where k is the level of
the invitation: level 0 (people directly invited)
yields 1 point, level 1 (people invited by
someone invited by the original customer) gives
1/2 points, level 2 invitations (people invited
by someone on level 1) awards 1/4 points and so
on. Only the first invitation counts: multiple
invites sent to the same person don't produce
any further points, even if they come from
different inviters and only the first invitation
counts.

## Implementation
### HTTP endpoint
Exposed an HTTP endpoint which accept a plain
text file of reward commands.

Sample file content:
```
2018-06-12 09:41 A recommends B
2018-06-14 09:41 B accepts
2018-06-16 09:41 B recommends C
2018-06-17 09:41 C accepts
2018-06-19 09:41 C recommends D
2018-06-23 09:41 B recommends D
2018-06-25 09:41 D accepts
```

### Reward calculation
It validates the input and formats the records.
It sorts the formatted records in the ascending
order of datetime. Then it builds a tree of the
formatted records with the association to the
inviter. While building the tree it add points
to the inviter based on the acceptance of the
invitee.

## Setup instructions
### Prerequisites
The setups steps expect following tools installed
on the system.

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) 2.7.2
- [Bundler](https://bundler.io/) 2.1.4

### 1. Check out the repository
```bash
git clone git@github.com:sayuj/reward-system.git
```

### 2. Bundle install
```bash
bundle install
```

### 3. Run RSpec test
All RSpec files are in spec/ directory.

```bash
bundle exec rspec
```

### 4. Check code coverage
Code coverage is configured for RSpec tests.
`SimpleCov` is used for this.
Open `coverage/index.html` in any browser
to see the coverage report.

### 5. Check code style
RuboCop is used for static code styling.

```bash
bundle exec rubocop
```
### 6. Start the application server
You can start the application server using the
command given below.

```bash
bundle exec ruby app.rb
```

## Deployment
The latest version of this has been deployed to
Heroku.

URL: https://reward-point.herokuapp.com/

## Usage
This can be use in 2 different ways to calculate
reward points.

### 1. Input as a file

```bash
curl --location --request POST 'https://reward-point.herokuapp.com/rewards' \
    --header 'Content-Type: text/plain' \
    --data-binary '@/path/to/file'
```

### 2. Input as raw text

```bash
curl --location --request POST 'https://reward-point.herokuapp.com/rewards' \
    --header 'Content-Type: text/plain' \
    --data-raw '2018-06-12 09:41 A recommends B
    2018-06-12 09:41 A recommends B
    2018-06-14 09:41 B accepts
    2018-06-16 09:41 B recommends C
    2018-06-17 09:41 C accepts
    2018-06-19 09:41 C recommends D
    2018-06-20 09:41 B recommends D
    2018-06-25 09:41 D accepts'
```
### Sample response

```json
{"A":1.75,"B":1.5,"C":1.0}
```
