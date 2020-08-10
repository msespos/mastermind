A command-line implementation of the classic game Mastermind, using OOP.

Play the game here:

https://repl.it/@msespos/mastermind#README.md

The object of Mastermind is to use a series of educated guesses, based on feedback on those guesses, to guess a predetermined secret code.
There are multiple versions of this game. This implementation uses a secret code that is a list of four colors. Each color is selected from one of six options. Colors can be repeated in a code, so that for example

- red yellow cyan magenta (rycm)

could be a code, but so could

- red red yellow yellow (rryy)

or even

- red red red red red (rrrr).

The six color choices in this implementation are red, yellow, green, cyan, blue, and magenta.

There are two players in Mastermind. In this implementation, the two players are the user and the computer. The user can be either the "guesser" (aka the code breaker) or the "creator" (aka the code maker). If the user is the guesser, the computer generates a random code and the user gets 12 attempts to guess it, using the feedback (see below). If the user guesses the code correctly within 12 guesses, they win. Otherwise, the computer wins.

If the user is the creator, they get to choose the code. The computer then guesses the code, using the Swaszek algorithm, a simplified version of the Knuth algorithm (see below). With Swaszek the computer will guess the code with an expected number of 4.638 guesses.

The feedback used to aid the guesser (user or computer) is a set of up to four "pegs" which are shown to the guesser after each guess. For each color that was correctly guessed and in the correct position, a black peg (red on the repl.it page) is revealed. For each color that was correctly guessed but is not in the correct position, a white peg is revealed. For example:

if rbyg is the secret code:
- a guess of rmmg would result in feedback of 1 black and 1 white peg
- a guess of rbgy would result in feedback of 2 black and 2 white pegs

If the feedback is four black pegs, then the game is over and the guesser has won (assuming they have not gone over the 12 guess limit).

The algorithm used for the computer guessing is a simplified version, implemented by Swaszek, of the famous Knuth algorithm. In the Swaszek algorithm, the computer begins by creating the set of all possible guesses. The first guess of rryy is then made. Then once the computer receives the feedback, it eliminates from the original set all guesses that could not satisfy the combination of that guess and the given feedback. The computer then makes its next guess by choosing randomly from the set of remaining guesses. (In the Knuth algorithm a more sophisticated process is used than random selection at this point.) The process is then repeated until the set has been narrowed down to one guess, or the computer guesses correctly from the set.

In this version of the game, if the user is the creator, the size of the set of remaining possible guesses is shown after each computer guess.

This was the first project in The Odin Project in which I made significant use of OOP, with more than two classes separated into multiple files. It represented a significant leap forward in my understanding of the topic.

Thanks to AA for helping with a particularly difficult debugging session late into the project.
